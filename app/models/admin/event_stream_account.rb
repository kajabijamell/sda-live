# == Schema Information
#
# Table name: admin_event_stream_accounts
#
#  id                      :bigint           not null, primary key
#  response                :json
#  response_status         :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  admin_event_id          :bigint           not null
#  admin_stream_account_id :bigint           not null
#  facebook_live_video_id  :string
#  youtube_broadcast_id    :string
#  youtube_stream_id       :string
#
# Indexes
#
#  index_admin_event_stream_accounts_on_admin_event_id           (admin_event_id)
#  index_admin_event_stream_accounts_on_admin_stream_account_id  (admin_stream_account_id)
#
# Foreign Keys
#
#  fk_rails_...  (admin_event_id => admin_events.id)
#  fk_rails_...  (admin_stream_account_id => admin_stream_accounts.id)
#
class Admin::EventStreamAccount < ApplicationRecord
  belongs_to :event, class_name: 'Admin::Event', foreign_key: :admin_event_id
  belongs_to :stream_account, class_name: 'Admin::StreamAccount', foreign_key: :admin_stream_account_id
end
