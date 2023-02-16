module Conversations
  class ConversationLiteSerializer < ActiveModel::Serializer
    attributes :id, :recipient
  end
end
