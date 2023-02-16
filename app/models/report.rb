class Report < ApplicationRecord
  belongs_to :user
  belongs_to :reportable, polymorphic: true

  validates :user, uniqueness: { scope: :reportable }
end
