class AddAdminLiveStreamToAdminEvents < ActiveRecord::Migration[6.0]
  def change
    add_reference :admin_events, :admin_live_stream, null: true, foreign_key: false
  end
end
