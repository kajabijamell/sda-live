# == Schema Information
#
# Table name: admin_stream_accounts
#
#  id            :bigint           not null, primary key
#  expires_at    :datetime
#  name          :string
#  provider      :string
#  refresh_token :text
#  token         :text
#  uid           :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  church_id     :bigint           not null
#
# Indexes
#
#  index_admin_stream_accounts_on_church_id  (church_id)
#
# Foreign Keys
#
#  fk_rails_...  (church_id => churches.id)
#
class Admin::StreamAccount < ApplicationRecord
  belongs_to :church
  has_and_belongs_to_many :events, class_name: 'Admin::Event'

  def self.from_omniauth(auth, user)
    stream_account = find_by(uid: auth['uid'], provider: auth['provider'])
    stream_account = create(uid: auth['uid'], provider: auth['provider']) if stream_account.blank?
    stream_account.church_id = user.church.id
    stream_account.name = auth['info']['name']
    stream_account.token = auth['credentials']['token']
    stream_account.refresh_token = auth['credentials']['refresh_token']
    if auth['credentials']['expires_at'].present?
      stream_account.expires_at =  Time.at(auth['credentials']['expires_at'])
    end
    stream_account.save
    stream_account
  end

  def provider_text
    provider == 'google_oauth2' ? 'Youtube' : 'Facebook'
  end

  def latest_token
    if provider == 'google_oauth2'
      refresh! if expires_at.blank? || expires_at < Time.now
    end
    token
  end

  private

  def to_params
    {
      'refresh_token': refresh_token,
      'client_id': ENV['GOOGLE_CLIENT_ID'],
      'client_secret': ENV['GOOGLE_CLIENT_SECRET'],
      'grant_type': 'refresh_token'
    }
  end

  def request_token
    if provider == 'google_oauth2'
      url = URI('https://accounts.google.com/o/oauth2/token')
      Net::HTTP.post_form(url, to_params)
    else
      url = URI("https://graph.facebook.com/oauth/access_token?grant_type=fb_exchange_token
&client_id=#{ENV['FACEBOOK_APP_ID']}&client_secret=#{ENV['FACEBOOK_APP_SECRET']}&fb_exchange_token=#{token}")
      Net::HTTP.get(url)
    end
  end

  def refresh!
    data = JSON.parse(request_token.body)
    update(
      token: data['access_token'],
      expires_at: Time.now + data['expires_in'].to_i.seconds
    )
  end
end
