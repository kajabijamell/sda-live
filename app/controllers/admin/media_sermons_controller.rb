# frozen_string_literal: true
class Admin::MediaSermonsController < ApplicationController
  before_action :set_admin_media_sermon, only: [:show, :edit, :update, :destroy]

  layout "admin"

  # GET /admin/media_sermons
  # GET /admin/media_sermons.json
  def index
    params[:view] ||= 'grid'
    @admin_media_sermons = current_user.church.media_sermons.order("#{sort_column} #{sort_direction}")
  end

  # GET /admin/media_sermons/1
  def show; end

  # GET /admin/media_sermons/new
  def new
    @admin_media_sermon = current_user.church.media_sermons.new
  end

  # GET /admin/media_sermons/1/edit
  def edit
    @admin_media_sermons = current_user.church.media_sermons
  end

  # POST /admin/media_sermons
  def create
    @admin_media_sermon = current_user.church.media_sermons.new(create_admin_media_sermon_params)

    if @admin_media_sermon.save
      if params[:video].present?
        video_json = JSON.parse(params[:video])
        if video_json[0].present?
          video_data = build_media_json(video_json[0])
          @admin_media_sermon.update video_data: video_data
          ThumbnailGenerateJob.perform_later(@admin_media_sermon.id)
          # @admin_media_sermon.generate_hls_video if create_admin_media_sermon_params[:video].present?
        end
      end
      redirect_to admin_media_sermons_url, notice: 'Media sermon was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /admin/media_sermons/1
  def update
    if @admin_media_sermon.update(update_admin_media_sermon_params)
      if params[:video].present?
        video_json = JSON.parse(params[:video])
        if video_json[0].present?
          video_data = build_media_json(video_json[0])
          @admin_media_sermon.update video_data: video_data
          ThumbnailGenerateJob.perform_later(@admin_media_sermon.id)
          # @admin_media_sermon.generate_hls_video if create_admin_media_sermon_params[:video].present?
        end
      end
      # @admin_media_sermon.generate_hls_video if update_admin_media_sermon_params[:video].present?
      redirect_to admin_media_sermons_url(view: params[:view] || 'grid'), notice: 'Media sermon was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /admin/media_sermons/1
  def destroy
    @admin_media_sermon.destroy
    redirect_to admin_media_sermons_url(view: params[:view] || 'grid'), notice: 'Media sermon was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_admin_media_sermon
    @admin_media_sermon = current_user.church.media_sermons.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def create_admin_media_sermon_params
    params.require(:admin_media_sermon).permit(:title, :speaker, :scripture, :church_id, :video, :thumbnail, :published)
  end

  # Only allow a list of trusted parameters through.
  def update_admin_media_sermon_params
    params.require(:admin_media_sermon).permit(:title, :speaker, :scripture, :church_id, :thumbnail, :published)
  end

  def build_media_json(file)
    {
      id: "#{file['successful'][0]['uploadURL'].split('amazonaws.com/')[1]}",
      storage: 'store',
      metadata: {
        size: file['successful'][0]['size'],
        filename: file['successful'][0]['name'],
        mime_type: file['successful'][0]['meta']['type']
      }
    }.to_json
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  end

  def sort_column
    Admin::MediaSermon.column_names.include?(params[:sort]) ? params[:sort] : 'created_at'
  end
end
