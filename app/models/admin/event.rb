# == Schema Information
#
# Table name: admin_events
#
#  id                   :bigint           not null, primary key
#  address              :text
#  description          :text
#  discarded_at         :datetime
#  end_datetime         :datetime
#  image_data           :text
#  is_live_stream       :boolean          default(FALSE)
#  link                 :string
#  location             :string
#  name                 :string
#  published            :boolean          default(FALSE)
#  start_datetime       :datetime
#  status               :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  admin_live_stream_id :bigint
#  church_id            :bigint
#
# Indexes
#
#  index_admin_events_on_admin_live_stream_id  (admin_live_stream_id)
#  index_admin_events_on_church_id             (church_id)
#  index_admin_events_on_discarded_at          (discarded_at)
#
class Admin::Event < ApplicationRecord
  include Discard::Model

  belongs_to :church
  belongs_to :live_stream, class_name: 'Admin::LiveStream', foreign_key: :admin_live_stream_id, required: false
  has_many :event_stream_accounts, class_name: 'Admin::EventStreamAccount', foreign_key: :admin_event_id,
                                   dependent: :destroy
  has_many :http_requests, as: :entity

  validates_presence_of :name, :start_datetime, :end_datetime, :address, :description, :link, :location
  validates_length_of :location, maximum: 150
  # has_one_attached :image
  include ImageUploader::Attachment(:image)

  enum status: { created_livestream: 0, failed_creating_livestream: 1,
                 partial_livestreams_created: 2, success_livestreams_created: 3,
                 partial_targets_added: 4, failed_targets_added: 5, success_targets_added: 6,
                 failed_discarding_livestream: 7, succeeded_discarding_livestream: 8,
                 updated_livestream: 9, failed_livestream_update: 10 }
end
