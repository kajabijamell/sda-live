# == Schema Information
#
# Table name: admin_media_sermons
#
#  id                :bigint           not null, primary key
#  hls_thumbnail_url :text
#  hls_url           :text
#  published         :boolean          default(FALSE)
#  scripture         :string
#  speaker           :string
#  thumbnail_data    :text
#  title             :string
#  video_data        :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  church_id         :bigint           not null
#
# Indexes
#
#  index_admin_media_sermons_on_church_id  (church_id)
#
# Foreign Keys
#
#  fk_rails_...  (church_id => churches.id)
#
class Admin::MediaSermon < ApplicationRecord
  belongs_to :church

  scope :published, -> { where(published: true) }
  scope :unpublished, -> { where(published: false) }

  # has_one_attached :image
  include VideoUploader::Attachment(:video)
  include ImageUploader::Attachment(:thumbnail)

  validates :title, presence: true

  before_destroy :delete_hls_video

  def get_video_url
    hls_url || video&.url(host: ENV['CLOUDFRONT_ASSETS_ENDPOINT'], public: true)
  end

  def get_video_type
    hls_url ? 'application/x-mpegURL' : ''
  end

  def get_thumbnail_url
    thumbnail&.url(host: ENV['CLOUDFRONT_ASSETS_ENDPOINT'], public: true) || hls_thumbnail_url
  end

  def generate_hls_video
    puts 'Started Deleting old HLS if present'
    delete_hls_video
    puts 'Completed Deleting old HLS if present'
    update(hls_url: nil, hls_thumbnail_url: nil)
    GenerateHlsJob.perform_later(id)
  end

  def delete_hls_video
    return if hls_url.blank?

    s3 = Aws::S3::Resource.new
    folder = "mediasermon/#{id}/video/"
    objects = s3.bucket('sda-live-hls').objects({prefix: folder})
    objects.batch_delete!
  end
end
