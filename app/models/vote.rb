class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votetable, polymorphic: true
  has_many :notifications, as: :notificationable

  validates :user, uniqueness: { scope: :votetable }
  after_create :create_notifications

  private

  def create_notifications
    parent = votetable
    parent = parent.votetable while parent.is_a? Vote
    make_notify(votetable.user, user, 'voted', parent)
  end
end
