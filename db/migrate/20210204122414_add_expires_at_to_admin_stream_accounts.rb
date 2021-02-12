class AddExpiresAtToAdminStreamAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :admin_stream_accounts, :expires_at, :datetime
  end
end
