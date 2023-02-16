class Favourite < ApplicationRecord
  include NotifyConcern

  belongs_to :user
  belongs_to :post
  # has_many :posts, source: :user
  # has_many :favourite_posts, through: :favourites, source: :user
  has_many :notifications, as: :notificationable
  validates :post, uniqueness: { scope: :user }
  validates :user, uniqueness: { scope: :post }
  after_create :create_notifications

  private

  def create_notifications
    make_notify(post.user, user, 'favourited', post)
  end
end
