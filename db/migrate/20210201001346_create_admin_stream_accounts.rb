class CreateAdminStreamAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :admin_stream_accounts do |t|
      t.belongs_to :church, null: false, foreign_key: true
      t.string :provider
      t.string :uid
      t.string :name
      t.string :refresh_token

      t.timestamps
    end
  end
end
