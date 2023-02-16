class CommentSerializer < ActiveModel::Serializer
  attributes :id,
             :body,
             :created_at,
             :vote_sum

  belongs_to :user, serializer: ::Users::UserLiteSerializer
  has_many :comments, serializer: self

  def comments
    object.comments.order(id: :desc)
  end
end
