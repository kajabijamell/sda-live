class AdminEventLiveStreamJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: false

  def perform(admin_event_id, stream_account_ids)
    admin_event = Admin::Event.find_by(id: admin_event_id)
    admin_live_stream = admin_event.church.live_streams.new(name: "#{admin_event.name} live stream")
    admin_live_stream.playback_policy = MuxRuby::PlaybackPolicy::PUBLIC
    if admin_live_stream.save
      live_stream = MuxLiveStream.new
      mux_live_stream = live_stream.create(admin_live_stream)
      if mux_live_stream&.data&.id
        admin_event.update(admin_live_stream_id: admin_live_stream.id)
        admin_live_stream.update(mux_stream_id: mux_live_stream.data.id,
                                 mux_stream_key: mux_live_stream.data.stream_key)
        admin_event.created_livestream!
        AdminEventStreamAccountsJob.perform_later(admin_event_id, stream_account_ids)
      else
        admin_live_stream.discard
        admin_event.failed_creating_livestream!
      end
    else
      admin_event.failed_creating_livestream!
    end
  end
end
