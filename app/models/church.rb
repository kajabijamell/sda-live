# == Schema Information
#
# Table name: churches
#
#  id           :bigint           not null, primary key
#  address      :text
#  fb           :string
#  give_link    :text
#  instagram    :string
#  logo_data    :text
#  name         :string
#  phone_number :string
#  youtube      :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_churches_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Church < ApplicationRecord
  belongs_to :user
  has_many :news, class_name: 'Admin::News', dependent: :destroy
  has_many :events, class_name: 'Admin::Event', dependent: :destroy
  has_many :media_images, class_name: 'Admin::MediaImage', dependent: :destroy
  has_many :media_sermons, class_name: 'Admin::MediaSermon', dependent: :destroy
  has_one :website, class_name: 'Admin::Website', dependent: :destroy
  has_many :members, class_name: 'Admin::Member', dependent: :destroy
  has_many :live_streams, class_name: 'Admin::LiveStream', dependent: :destroy
  has_many :stream_accounts, class_name: 'Admin::StreamAccount', dependent: :destroy

  # has_one_attached :logo
  include ImageUploader::Attachment(:logo)
end
