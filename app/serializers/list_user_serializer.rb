# Show a list of users

class ListUserSerializer < ActiveModel::Serializer
  attributes :name,
             :email,
             :image_url
end
