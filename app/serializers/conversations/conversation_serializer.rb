# Show a conversation with all destails
module Conversations
  class ConversationSerializer < ActiveModel::Serializer
    attributes :id, :recipient, :sender
    has_many :messages, serializer: MessageSerializer
  end
end
