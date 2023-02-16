# show user's profile
module Users
  class UserSerializer < ActiveModel::Serializer
    attributes :name,
               :email,
               :image_url,
               :follower_count,
               :following_count
  end
end
