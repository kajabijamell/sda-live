class AdminEventLiveStreamDiscardJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: false

  def perform(admin_event_id)
    admin_event = Admin::Event.find_by(id: admin_event_id)
    live_stream = MuxLiveStream.new
    delete_resp = live_stream.delete(admin_event.live_stream)
    if delete_resp
      admin_event.event_stream_accounts.each do |event_stream_account|
        response = if event_stream_account.stream_account.provider == 'facebook'
                     Facebook::LiveVideo.new.delete_broadcast(
                       admin_event,
                       event_stream_account.stream_account,
                       event_stream_account.facebook_live_video_id
                     )
                   else
                     Youtube::LiveVideo.new.delete_broadcast(
                       admin_event,
                       event_stream_account.youtube_broadcast_id,
                       event_stream_account.stream_account
                     )
                     Youtube::LiveVideo.new.delete_livestream(
                       admin_event,
                       event_stream_account.youtube_stream_id,
                       event_stream_account.stream_account
                     )
                   end
        if response && response.code == '200'
          admin_event.succeeded_discarding_livestream!
        else
          admin_event.failed_discarding_livestream!
        end
      end
      admin_event.succeeded_discarding_livestream!
    else
      admin_event.failed_discarding_livestream!
    end
  end
end
