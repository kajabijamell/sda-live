class MuxLiveStream
  def initialize
    @live_api = MuxRuby::LiveStreamsApi.new
  end

  def create(admin_live_stream, asset_url = nil)
    create_asset_request = create_asset_request_obj(asset_url)
    create_live_stream_request = create_live_stream_request_obj(create_asset_request, admin_live_stream)
    @live_api.create_live_stream(create_live_stream_request)
  rescue MuxRuby::ApiError => e
    puts e.message
    false
  end

  def add_simulcast_target(mux_live_stream_id, id, url, stream_key)
    create_simulcast_target = MuxRuby::CreateSimulcastTargetRequest.new
    create_simulcast_target.passthrough = id.to_s
    create_simulcast_target.stream_key = stream_key
    create_simulcast_target.url = url
    @live_api.create_live_stream_simulcast_target(mux_live_stream_id, create_simulcast_target)
  rescue MuxRuby::ApiError => e
    puts e.message
    false
  end

  def delete_simulcast_target(mux_live_stream_id, mux_simulcast_id)
    @live_api.delete_live_stream_simulcast_target(mux_live_stream_id, mux_simulcast_id)
  rescue StandardError => e
    puts e.message
    false
  end

  def delete(admin_live_stream)
    @live_api.delete_live_stream(admin_live_stream.mux_stream_id)
    admin_live_stream.admin_simulcast_targets.each do |simulcast_target|
      simulcast_target.discard
    end
    admin_live_stream.discard
  rescue MuxRuby::ApiError => e
    puts e.message
    false
  end

  private

  def create_asset_request_obj(asset_url = nil)
    create_asset_request = MuxRuby::CreateAssetRequest.new
    create_asset_request.playback_policy = [MuxRuby::PlaybackPolicy::PUBLIC]
    create_asset_request.mp4_support = 'standard'
    if asset_url.present?
      create_asset_request.input = {
        url: asset_url,
        overlay_settings: {
          vertical_align: 'middle'
        }
      }
    end
    create_asset_request
  end

  def create_live_stream_request_obj(create_asset_request, admin_live_stream)
    create_live_stream_request = MuxRuby::CreateLiveStreamRequest.new
    create_live_stream_request.new_asset_settings = create_asset_request
    create_live_stream_request.playback_policy = [admin_live_stream.playback_policy]
    create_live_stream_request.reduced_latency = true
    create_live_stream_request.passthrough = admin_live_stream.id.to_s
    # create_live_stream_request.test = true if Rails.env.development?
    create_live_stream_request
  end
end