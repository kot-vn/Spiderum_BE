# Show all current user's post
module Users
  class MyPostsSerializer < ActiveModel::Serializer
    has_many :posts, serializer: ::Posts::PostLiteSerializer
  end
end
