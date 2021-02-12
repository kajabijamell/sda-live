class AddDiscardedAtToEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :admin_events, :discarded_at, :datetime

    add_index :admin_events, :discarded_at
  end
end
