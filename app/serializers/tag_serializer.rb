# Show all post with this tag

class TagSerializer < ActiveModel::Serializer
  attributes :tag_name
  has_many :posts
end
