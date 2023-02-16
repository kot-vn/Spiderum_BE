module Users
  class UserLiteSerializer < ActiveModel::Serializer
    attributes :id,
               :image_url,
               :name
  end
end
