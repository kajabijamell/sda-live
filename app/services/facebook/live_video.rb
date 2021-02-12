require 'resolv-replace'
require 'net/http'
require 'uri'
class Facebook::LiveVideo
  STATUS = {
    unpublished: 'UNPUBLISHED',
    live_now: 'LIVE_NOW',
    scheduled_unpublished: 'SCHEDULED_UNPUBLISHED',
    scheduled_live: 'SCHEDULED_LIVE',
    scheduled_cancelled: 'SCHEDULED_CANCELED'
  }.freeze

  def schedule_broadcast(event, stream_account)
    status = event_status(event)
    url = "https://graph.facebook.com/#{stream_account.uid}/live_videos?
status=#{status}&title=#{event.name}&description=#{event.description}
&planned_start_time=#{event.start_datetime.to_i}&access_token=#{stream_account.latest_token}"
    send_post_request(event, url)
  end

  def update_broadcast(event, stream_account, live_video_id)
    status = event_status(event)
    url = "https://graph.facebook.com/#{live_video_id}?
status=#{status}&title=#{event.name}&description=#{event.description}
&planned_start_time=#{event.start_datetime.to_i}&access_token=#{stream_account.latest_token}"
    send_post_request(event, url)
  end

  def go_live(event, stream_account, live_video_id)
    url = "https://graph.facebook.com/#{live_video_id}?status=LIVE_NOW&access_token=#{stream_account.latest_token}"
    send_post_request(event, url)
  end

  def delete_broadcast(event, stream_account, live_video_id)
    url = "https://graph.facebook.com/#{live_video_id}?access_token=#{stream_account.latest_token}"
    send_delete_request(event, url)
  end

  def remove_permission(stream_account)
    url = "https://graph.facebook.com/#{stream_account.uid}/permissions?access_token=#{stream_account.latest_token}"
    send_delete_request(nil, url)
  end

  private

  def send_post_request(event, url)
    http_request = HttpRequest.create(url: url, entity: event, type_of_request: :post, body: {})
    uri = URI.parse(url)
    request = Net::HTTP::Post.new(uri)
    req_options = { use_ssl: uri.scheme == 'https' }
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    http_request.update(response_code: response.code, response_body: JSON.parse(response.body))
    response
  rescue StandardError => _e
    puts _e.message
    false
  end

  def send_delete_request(event, url)
    http_request = HttpRequest.create(url: url, entity: event, type_of_request: :deletee, body: {})
    uri = URI.parse(url)
    request = Net::HTTP::Delete.new(uri)
    req_options = { use_ssl: uri.scheme == 'https' }
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    http_request.update(response_code: response.code, response_body: JSON.parse(response.body))
    response
  rescue StandardError => _e
    puts _e.message
    false
  end

  def event_status(event)
    if event.published
      STATUS[:scheduled_live]
    else
      STATUS[:scheduled_unpublished]
    end
  end
end