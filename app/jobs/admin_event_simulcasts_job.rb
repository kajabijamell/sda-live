class AdminEventSimulcastsJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: false

  def perform(event_id, event_stream_account_id)
    event = Admin::Event.find(event_id)
    event_stream_account = Admin::EventStreamAccount.find(event_stream_account_id)
    live_stream = event.live_stream
    stream_account = event_stream_account.stream_account
    if stream_account.provider == 'facebook'
      full_url = event_stream_account.response['secure_stream_url']
      components = full_url.split('rtmp/')
      stream_key = components[1]
      url = "#{components[0]}rtmp/"
    else
      stream_key = event_stream_account.response['livestream']['cdn']['ingestionInfo']['streamName']
      url = event_stream_account.response['livestream']['cdn']['ingestionInfo']['ingestionAddress']
    end
    target = live_stream.admin_simulcast_targets.create(platform: stream_account.provider_text,
                                                        url: url, stream_key: stream_key)
    target_resp = MuxLiveStream.new.add_simulcast_target(live_stream.mux_stream_id, target.id, target.url, target.stream_key)
    if target_resp&.data&.id
      target.update(mux_simulcast_id: target_resp.data.id)
      event.success_targets_added!
    else
      event.failed_targets_added!
    end
  end
end
