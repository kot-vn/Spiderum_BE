class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token

  devise :database_authenticatable

  has_many :posts, dependent: :destroy
  has_many :favourites, dependent: :destroy
  has_many :posts, through: :favourites, source: :user
  has_many :relationships, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :notifications, dependent: :destroy, foreign_key: :recipient_id
  has_one_attached :image

  has_many :active_relationships, class_name: 'Relationship',
                                  foreign_key: 'follower_id', dependent: :destroy
  has_many :passive_relationships, class_name: 'Relationship',
                                   foreign_key: 'followed_id', dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  has_many :messages
  has_many :conversations, foreign_key: :sender_id

  before_save :downcase_email
  before_create :generate_confirmation_instructions

  attribute :image_url
  after_find :set_image_url

  validates :image,
            content_type: {
              in: %w[image/jpeg image/gif image/png],
              message: 'must be a valid image format'
            },
            size: { less_than: 5.megabytes, message: 'should be less than 5MB' }

  TOKEN_EXPIRE = 15.days.from_now.to_i

  def create_token
    JWT.encode({ id:, exp: TOKEN_EXPIRE }, Rails.application.secrets.secret_key_base)
    # payload: { id: id, exp: TOKEN_EXPIRE } , secret key: Rails.application.secrets.secret_key_base
  end

  def feed
    following_ids = 'SELECT followed_id FROM relationships WHERE follower_id = :user_id'
    Post.where("user_id IN (#{following_ids})OR user_id = :user_id", user_id: id)
        .includes(:user, image_attachment: :blob)
  end

  # Follows a user.
  def follow(other_user)
    following << other_user unless self == other_user
  end

  # Unfollows a user.
  def unfollow(other_user)
    following.delete(other_user)
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Sends update email.
  def send_update_email
    UserMailer.update_email(self).deliver_now
  end

  # Create new token for confirmation account
  def generate_confirmation_instructions
    self.confirmation_token = SecureRandom.hex(10)
    self.confirmation_sent_at = Time.now.utc
  end

  def confirmation_token_valid?
    (confirmation_sent_at + 30.days) > Time.now.utc
  end

  def mark_as_confirmed!
    self.confirmation_token = nil
    self.confirmed_at = Time.now.utc
    save
  end

  # Create new token for reset password
  def generate_password_token!
    self.reset_password_token = generate_token
    self.reset_password_sent_at = Time.now.utc
    save!
  end

  def password_token_valid?
    (reset_password_sent_at + 2.hours) > Time.now.utc
  end

  def reset_password!(password)
    self.reset_password_token = nil
    self.password = password
    save!
  end

  def update_new_email!(email)
    self.unconfirmed_email = email
    generate_confirmation_instructions
    save
  end

  def update_new_email
    self.email = unconfirmed_email
    self.unconfirmed_email = nil
    mark_as_confirmed!
  end

  def self.email_used?(email)
    existing_user = find_by('email = ?', email)
    if existing_user.present?
      true
    else
      waiting_for_confirmation = find_by('unconfirmed_email = ?', email)
      waiting_for_confirmation.present? && waiting_for_confirmation.confirmation_token_valid?
    end
  end

  private

  # Converts email to all lower-case.
  def downcase_email
    self.email = email.downcase
  end

  def generate_token
    SecureRandom.hex(10)
  end
end
