class ReportSerializer < ActiveModel::Serializer
  attributes :id,
             :reason,
             :reportable_type,
             :reportable_id,
             :created_at

  belongs_to :user, serializer: ::Users::UserLiteSerializer
end
