class AddIsLiveStreamToAdminEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :admin_events, :is_live_stream, :boolean, default: false
  end
end
