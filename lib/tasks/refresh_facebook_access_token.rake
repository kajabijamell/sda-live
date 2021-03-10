# frozen_string_literal: true

task refresh_facebook_access_token: :environment do
  puts '############  Refresh facebook token start  ############'
  Admin::StreamAccount.where(provider: 'facebook')
  puts '############  Refresh facebook token End  ############'
end
