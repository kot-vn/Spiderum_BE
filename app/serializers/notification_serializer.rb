# Show list of notifications
class NotificationSerializer < ActiveModel::Serializer
  attributes :id,
             :actor,
             :notificationable_type,
             :notificationable_id,
             :action, :created_at

  belongs_to :actor, class_name: 'User', serializer: ::Users::UserLiteSerializer
end
