class MessageSerializer < ActiveModel::Serializer
  attributes :mes_content,
             :conversation_id,
             :created_at
             
  belongs_to :conversation
  belongs_to :user, serializer: ::Users::UserLiteSerializer
end
