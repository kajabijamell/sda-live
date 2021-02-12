class AdminEventStreamAccountsJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: false

  def perform(admin_event_id, stream_account_ids)
    admin_event = Admin::Event.find_by(id: admin_event_id)
    stream_accounts = admin_event.church.stream_accounts.where(id: stream_account_ids)
    stream_accounts.each do |sa|
      if sa.provider == 'facebook'
        puts "\n\n\n\n##### Provider #######"
        puts sa.provider
        puts "##### Provider Call ended #######\n\n\n\n"
        facebook_broadcast(sa, admin_event)
      else
        youtube_broadcast(sa, admin_event)
      end
    end
  end

  def facebook_broadcast(sa, event)
    facebook_live_video = Facebook::LiveVideo.new
    response = facebook_live_video.schedule_broadcast(event, sa)
    event_stream_account = Admin::EventStreamAccount.find_or_create_by(
      admin_event_id: event.id,
      admin_stream_account_id: sa.id
    )
    if response
      response_json = JSON.parse(response.body)
      if response.code == '200'
        event_stream_account.update(
          response: response_json,
          response_status: response.code,
          facebook_live_video_id: response_json['id']
        )
        AdminEventSimulcastsJob.perform_later(event.id, event_stream_account.id)
        success(event)
      else
        error(event)
      end
    else
      error(event)
    end
  end

  def youtube_broadcast(stream_account, event)
    youtube_live_video = Youtube::LiveVideo.new
    response_broadcast = youtube_live_video.schedule_broadcast(stream_account, event)
    event_stream_account = Admin::EventStreamAccount.find_or_create_by(admin_event_id: event.id,
                                                                       admin_stream_account_id: stream_account.id)
    response_broadcast_json = JSON.parse(response_broadcast.body)
    if response_broadcast.code == '200'
      response_livestream = youtube_live_video.create_livestream(stream_account, event)
      response_livestream_json = JSON.parse(response_livestream.body)
      if response_livestream.code == '200'
        response_broadcast = youtube_live_video.bind_live_stream(event, response_broadcast_json['id'],
                                                                 response_livestream_json['id'], stream_account)
        if response_broadcast.code == '200'
          event_stream_account.update(
            youtube_broadcast_id: response_broadcast_json['id'],
            youtube_stream_id: response_livestream_json['id'],
            response: {
              broadcast: response_broadcast_json,
              livestream: response_livestream_json
            },
            response_status: response_broadcast.code
          )
          AdminEventSimulcastsJob.perform_later(event.id, event_stream_account.id)
          success(event)
        else
          error(event)
        end
      else
        error(event)
        event_stream_account.update(
          response: {
            broadcast: response_broadcast_json,
            livestream: response_livestream_json
          },
          response_status: response_livestream.code
        )
      end
    else
      error(event)
      event_stream_account.update(
        response: {
          broadcast: response_broadcast_json
        },
        response_status: response_broadcast.code
      )
    end
  end

  def success(event)
    if event.failed_creating_livestream? || event.partial_livestreams_created?
      event.partial_livestreams_created!
    else
      event.success_livestreams_created!
    end
  end

  def error(event)
    if event.success_livestreams_created? || event.partial_livestreams_created?
      event.partial_livestreams_created!
    else
      event.failed_creating_livestream!
    end
  end
end
