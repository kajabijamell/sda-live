class CreateAdminEventStreamAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :admin_event_stream_accounts do |t|
      t.belongs_to :admin_event, null: false, foreign_key: true
      t.belongs_to :admin_stream_account, null: false, foreign_key: true
      t.json :response
      t.string :response_status

      t.timestamps
    end
  end
end
