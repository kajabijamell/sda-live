class Admin::LiveStreamsController < ApplicationController
  before_action :set_admin_live_stream, only: %i[show destroy new_target create_target destroy_target]

  layout "admin"

  # GET /admin/live_streams
  def index
    @admin_live_streams = current_user.church.live_streams
  end

  # GET /admin/live_stream/1
  def show; end

  # GET /admin/live_stream/new
  def new
    @admin_live_stream = current_user.church.live_streams.new
    @admin_live_stream.admin_simulcast_targets.new(platform: 'Facebook')
    @admin_live_stream.admin_simulcast_targets.new(platform: 'Youtube')
  end

  # POST /admin/live_streams
  def create
    @admin_live_stream = current_user.church.live_streams.new(admin_live_stream_params)
    @admin_live_stream.playback_policy = MuxRuby::PlaybackPolicy::PUBLIC
    if @admin_live_stream.save
      live_stream = MuxLiveStream.new
      mux_live_stream = live_stream.create(@admin_live_stream)
      if mux_live_stream&.data&.id
        success = true
        @admin_live_stream.admin_simulcast_targets.each do |target|
          target_resp = live_stream.add_simulcast_target(mux_live_stream.data.id, target.id, target.url, target.stream_key)
          unless target_resp&.data&.id
            success = false
            break
          end
          target.update(mux_simulcast_id: target_resp.data.id)
        end
        if success
          @admin_live_stream.update mux_stream_id: mux_live_stream.data.id, mux_stream_key: mux_live_stream.data.stream_key
          redirect_to @admin_live_stream, notice: 'Live stream was successfully created.'
        else
          @admin_live_stream.destroy
          redirect_to admin_live_streams_path, error: 'Something went wrong.'
        end
      else
        live_stream.delete(@admin_live_stream)
        @admin_live_stream.destroy
        redirect_to admin_live_streams_path, error: 'Something went wrong.'
      end
    else
      puts @admin_live_stream.errors.full_messages
      render :new
    end
  end

  # DELETE /admin/live_streams/1
  def destroy
    live_stream = MuxLiveStream.new
    delete_resp = live_stream.delete(@admin_live_stream)
    if delete_resp
      redirect_to admin_live_streams_url, notice: 'Live stream was successfully destroyed.'
    else
      redirect_to admin_live_streams_path, error: 'Something went wrong.'
    end
  end

  def new_target
    @target = @admin_live_stream.admin_simulcast_targets.new
  end

  def create_target
    @target = @admin_live_stream.admin_simulcast_targets.new(admin_simulcast_targets_params)
    if @target.save
      live_stream = MuxLiveStream.new
      target_resp = live_stream.add_simulcast_target(@admin_live_stream.mux_stream_id, @target.id, @target.url, @target.stream_key)
      if target_resp && target_resp&.data&.id
        @target.update(mux_simulcast_id: target_resp.data.id)
        flash[:notice] = 'Target was successfully created.'
        redirect_to @admin_live_stream
      else
        @target.destroy
        flash[:error] = 'Something went wrong.'
        redirect_to admin_live_stream_path
      end
    else
      flash.now[:error] = @target.errors.full_messages.first
      render :new_target
    end
  end

  def destroy_target
    @target = @admin_live_stream.admin_simulcast_targets.find_by(id: params[:target_id])
    if @target.present?
      live_stream = MuxLiveStream.new
      live_stream.delete_simulcast_target(@admin_live_stream.mux_stream_id, @target.mux_simulcast_id)
      @target.destroy
      flash.now[:success] = 'Target deleted'
    else
      flash.now[:error] = 'No target found'
    end
    redirect_to admin_live_stream_path
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_admin_live_stream
    @admin_live_stream = current_user.church.live_streams.find_by(id: params[:id])
    return unless @admin_live_stream.blank?

    flash[:error] = 'No live stream found'
    redirect_to admin_live_streams_path
  end

  # Only allow a list of trusted parameters through.
  def admin_live_stream_params
    params.require(:admin_live_stream)
          .permit(:name, :playback_policy,
                  admin_simulcast_targets_attributes: %i[id platform url stream_key _destroy])
  end

  def admin_simulcast_targets_params
    params.require(:admin_simulcast_target)
          .permit(:id, :platform, :url, :stream_key)
  end
end
