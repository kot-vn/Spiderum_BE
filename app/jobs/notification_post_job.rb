class NotificationPostJob < ApplicationJob
  queue_as :default

  def perform(post)
    @post = post
    post.create_notifications.perform_later
  end
end
