class AddTokenToAdminStreamAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :admin_stream_accounts, :token, :text
    change_column :admin_stream_accounts, :refresh_token, :text
  end
end
