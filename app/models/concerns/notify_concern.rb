module NotifyConcern
  extend ActiveSupport::Concern

  def make_notify(recipient, actor, action, notificationable)
    Notification.create(recipient: , actor: ,
      action: , notificationable: )
  end
end