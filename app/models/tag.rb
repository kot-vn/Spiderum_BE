class Tag < ApplicationRecord
  has_many :posts
  extend FriendlyId
  friendly_id :tag_name, use: :slugged
end
