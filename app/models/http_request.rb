# == Schema Information
#
# Table name: http_requests
#
#  id              :bigint           not null, primary key
#  body            :json
#  entity_type     :string
#  response_body   :json
#  response_code   :string
#  type_of_request :integer
#  url             :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  entity_id       :integer
#
class HttpRequest < ApplicationRecord
  belongs_to :entity, polymorphic: true, required: false

  enum type_of_request: %i[get post patch put deletee]
end
