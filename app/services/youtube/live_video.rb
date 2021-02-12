require 'resolv-replace'
require 'net/http'
require 'uri'
require 'json'
class Youtube::LiveVideo
  def schedule_broadcast(stream_account, event)
    url = "https://youtube.googleapis.com/youtube/v3/liveBroadcasts?part=snippet,contentDetails,status&key=#{ENV['GOOGLE_KEY']}"
    json = {
      'snippet' => {
        'title' => event.name,
        'scheduledStartTime' => event.start_datetime.iso8601,
        'scheduledEndTime' => event.end_datetime.iso8601
      },
      'contentDetails' => {
        'enableClosedCaptions' => true,
        'enableContentEncryption' => true,
        'enableDvr' => true,
        'enableEmbed' => true,
        'recordFromStart' => true,
        'startWithSlate' => true
      },
      'status' => {
        'privacyStatus' => status(event)
      }
    }
    send_post_request(event, url, stream_account.latest_token, json)
  end

  def create_livestream(stream_account, event)
    url = "https://youtube.googleapis.com/youtube/v3/liveStreams?
part=snippet%2Ccdn%2CcontentDetails%2Cstatus&key=#{ENV['GOOGLE_KEY']}"
    json = {
      'snippet' => {
        'title' => event.name
      },
      'cdn' => {
        'frameRate' => '60fps',
        'ingestionType' => 'rtmp',
        'resolution' => '1080p'
      }
    }

    send_post_request(event, url, stream_account.latest_token, json)
  end

  def bind_live_stream(event, broadcast_id, stream_id, stream_account)
    url = "https://youtube.googleapis.com/youtube/v3/liveBroadcasts/bind?
id=#{broadcast_id}&part=snippet&streamId=#{stream_id}&key=#{ENV['GOOGLE_KEY']}"
    send_post_request(event, url, stream_account.latest_token)
  end

  def update_broadcast(event, broadcast_id, stream_account)
    url = "https://youtube.googleapis.com/youtube/v3/liveBroadcasts?part=snippet,status&key=&key=#{ENV['GOOGLE_KEY']}"
    json = {
      'id' => broadcast_id,
      'snippet' => {
        'title' => event.name,
        'scheduledStartTime' => event.start_datetime.iso8601,
        'scheduledEndTime' => event.end_datetime.iso8601
      },
      'status' => {
        'privacyStatus' => status(event)
      }
    }
    send_put_request(event, url, stream_account.latest_token, json)
  end

  def update_live_stream(event, live_stream_id, stream_account)
    url = "https://youtube.googleapis.com/youtube/v3/liveStreams?part=snippet&key=&key=#{ENV['GOOGLE_KEY']}"
    json = {
      'id' => live_stream_id,
      'snippet' => {
        'title' => event.name,
        'description' => event.description
      }
    }
    send_put_request(event, url, stream_account.latest_token, json)
  end

  def delete_broadcast(event, broadcast_id, stream_account)
    url = "https://youtube.googleapis.com/youtube/v3/liveBroadcasts?id=#{broadcast_id}&key=#{ENV['GOOGLE_KEY']}"
    send_delete_request(event, url, stream_account.latest_token)
  end

  def delete_livestream(event, livestream_id, stream_account)
    url = "https://youtube.googleapis.com/youtube/v3/liveStreams?id=#{livestream_id}&key=#{ENV['GOOGLE_KEY']}"
    send_delete_request(event, url, stream_account.latest_token)
  end

  private

  def send_post_request(event, url, token, json = nil)
    http_request = HttpRequest.create(url: url, entity: event, type_of_request: :post, body: json)
    uri = URI.parse(url)
    request = Net::HTTP::Post.new(uri)
    request.content_type = 'application/json'
    request['Authorization'] = "Bearer #{token}"
    request['Accept'] = 'application/json'
    request.body = JSON.dump(json) if json.present?
    req_options = { use_ssl: uri.scheme == 'https' }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    http_request.update(response_code: response.code, response_body: JSON.parse(response.body))
    response
  rescue StandardError => _e
    false
  end

  def send_put_request(event, url, token, json = nil)
    http_request = HttpRequest.create(url: url, entity: event, type_of_request: :put, body: json)
    uri = URI.parse(url)
    request = Net::HTTP::Put.new(uri)
    request.content_type = 'application/json'
    request['Authorization'] = "Bearer #{token}"
    request['Accept'] = 'application/json'
    request.body = JSON.dump(json) if json.present?
    req_options = { use_ssl: uri.scheme == 'https' }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    http_request.update(response_code: response.code, response_body: JSON.parse(response.body))
    response
  rescue StandardError => _e
    false
  end

  def send_delete_request(event, url, token)
    http_request = HttpRequest.create(url: url, entity: event, type_of_request: :deletee, body: json)
    uri = URI.parse(url)
    request = Net::HTTP::Delete.new(uri)
    request.content_type = 'application/json'
    request['Authorization'] = "Bearer #{token}"
    request['Accept'] = 'application/json'
    req_options = { use_ssl: uri.scheme == 'https' }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    http_request.update(response_code: response.code, response_body: JSON.parse(response.body))
    response
  rescue StandardError => _e
    false
  end

  def status(event)
    event.published ? 'public' : 'private'
  end
end