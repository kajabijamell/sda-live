class AddStatusToAdminEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :admin_events, :status, :integer
  end
end
