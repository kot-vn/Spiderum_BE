# Show a single post with all details
module Posts
  class PostSerializer < ActiveModel::Serializer
    attributes :id, :title, :content, :view, :favourite_count,
               :vote_sum, :comment_count, :images_url, :created_at

    belongs_to :user, serializer: ::Users::UserLiteSerializer
    belongs_to :tag, serializer: ::AttachTagSerializer
  end
end
