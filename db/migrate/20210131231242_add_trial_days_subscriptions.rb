class AddTrialDaysSubscriptions < ActiveRecord::Migration[6.0]
  def change
    add_column :subscriptions, :trial_period_days, :integer
  end
end
