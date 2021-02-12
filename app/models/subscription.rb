# == Schema Information
#
# Table name: subscriptions
#
#  id                :bigint           not null, primary key
#  active            :boolean          default(FALSE)
#  live_streams      :integer
#  name              :string
#  price             :float
#  rank              :integer
#  stream_size       :integer
#  targets           :integer
#  trial_period_days :integer
#  video_storage     :integer
#  viewer_count      :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  stripe_price_id   :string
#  stripe_product_id :string
#
class Subscription < ApplicationRecord
  scope :archived, -> { where.not(active: false) }
  scope :active, -> { where(active: true) }

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :stream_size, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :targets, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :video_storage, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :viewer_count, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :rank, numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  has_many :subscription_profiles
end
