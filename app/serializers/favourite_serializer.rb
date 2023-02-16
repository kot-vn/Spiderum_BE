# Show list of users who favourited the post which is being displayed

class FavouriteSerializer < ActiveModel::Serializer
  belongs_to :user, serializer: ::Users::UserLiteSerializer
end
