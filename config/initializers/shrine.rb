require 'shrine'
require 'shrine/storage/file_system'
require 'shrine/storage/s3'

if Rails.env.development?
  Shrine.storages = {
    cache: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/cache'), # temporary
    store: Shrine::Storage::FileSystem.new('public', prefix: 'uploads') # permanent
  }
else
  s3_options = {
    bucket: ENV['S3_BUCKET'],
    region: 'us-west-1',
    access_key_id: ENV['S3_ACCESS_KEY_ID'],
    secret_access_key: ENV['S3_SECRET_ACCESS_KEY']
  }

  Shrine.storages = {
    cache: Shrine::Storage::S3.new(prefix: "cache", **s3_options),
    store: Shrine::Storage::S3.new(**s3_options)
  }
end

Shrine.plugin :activerecord           # loads Active Record integration
Shrine.plugin :cached_attachment_data # enables retaining cached file across form redisplays
Shrine.plugin :restore_cached_data    # extracts metadata for assigned cached files
Shrine.plugin :derivatives            # deriving different versions
Shrine.plugin :validation_helpers     # validations related to files
Shrine.plugin :pretty_location        # adds pretty locations
Shrine.plugin :determine_mime_type, analyzer: :marcel
Shrine.plugin :remote_url, max_size: 1024*1024*1024
