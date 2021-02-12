class AddFacebookLiveVideoIdToEventStreamAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :admin_event_stream_accounts, :facebook_live_video_id, :string
    add_column :admin_event_stream_accounts, :youtube_broadcast_id, :string
    add_column :admin_event_stream_accounts, :youtube_stream_id, :string
  end
end
