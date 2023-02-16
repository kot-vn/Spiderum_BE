# Show short post
# Use for posts index or new feed
module Posts
  class PostLiteSerializer < ActiveModel::Serializer
    attributes :id, :title, :content, :view, :favourite_count, :vote_sum,
               :comment_count, :images_url, :created_at
    belongs_to :user, serializer: ::Users::UserLiteSerializer
    belongs_to :tag, serializer: AttachTagSerializer
  end
end
