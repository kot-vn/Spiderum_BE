# Show all the current user's favourite posts
module Users
  class MyFavouritesSerializer < ActiveModel::Serializer
      belongs_to :post, serializer: ::Posts::PostLiteSerializer
  end
end
