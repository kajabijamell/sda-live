# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  fname                  :string
#  invitation_completed   :boolean          default(FALSE)
#  invite_sent_at         :datetime
#  invite_token           :string
#  lname                  :string
#  profile_picture_data   :text
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :integer          default("admin")
#  subdomain              :string
#  time_zone              :string
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email_and_subdomain   (email,subdomain) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :omniauthable,
         :recoverable, :rememberable, :validatable, request_keys: [:subdomain]

  enum role: { member: 0, admin: 1, super_admin: 2 }

  has_one :church, dependent: :destroy
  has_one :website, through: :church
  has_many :media_sermons, class_name: 'Admin::MediaSermon', through: :church
  has_many :live_streams, class_name: 'Admin::LiveStream', through: :church
  has_many :admin_live_stream_stats, class_name: 'Admin::LiveStreamStat', through: :live_streams
  has_one :subscription_profile, dependent: :destroy
  has_many :notifications, as: :recipient

  # has_one_attached :profile_picture
  include ImageUploader::Attachment(:profile_picture)

  accepts_nested_attributes_for :church

  validates_presence_of :fname, :lname
  validates_inclusion_of :time_zone, in: ActiveSupport::TimeZone.all.map(&:name)
  validates_uniqueness_of :subdomain, if: :admin?
  validates_format_of :subdomain, with: /\A^[A-Za-z0-9]+\Z/i, if: :admin?

  after_create :create_church, if: :admin?

  def create_church
    c = Church.new(user: self)
    c.save(validate: false)
  end

  def create_invitation_token
    generate_invitation_token
    update_attribute :invite_sent_at, Time.now.utc unless invite_sent_at
    send_devise_notification(:invitation_instructions, @raw_invitation_token)
  end

  def generate_invitation_token
    raw, enc = Devise.token_generator.generate(self.class, :invite_token)
    @raw_invitation_token = raw
    update_attribute :invite_token, enc
  end

  def valid_invitation?
    invite_token.present? && invitation_period_valid?
  end

  def invitation_period_valid?
    time = invite_sent_at
    (time && time.utc >= 6.hours.ago)
  end

  def self.find_by_invitation_token(original_token, only_valid)
    invitation_token = Devise.token_generator.digest(self, :invite_token, original_token)

    invitable = find_or_initialize_with_error_by(:invite_token, invitation_token)
    invitable.errors.add(:invitation_token, :invalid) if invitable.invite_token && invitable.persisted? && !invitable.valid_invitation?
    invitable unless only_valid && invitable.errors.present?
  end

  def self.find_for_authentication(warden_conditions)
    where(email: warden_conditions[:email],
          subdomain: warden_conditions[:subdomain]).first
  end

  def get_subdomain
    temp_subdomain = SecureRandom.hex(4)
    loop do
      temp_subdomain = SecureRandom.hex(4)
      break unless self.class.exists?(subdomain: temp_subdomain)
    end
    temp_subdomain
  end
end
