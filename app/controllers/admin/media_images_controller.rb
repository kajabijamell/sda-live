# frozen_string_literal: true
class Admin::MediaImagesController < ApplicationController
  before_action :set_admin_media_image, only: [:show, :edit, :update, :destroy]

  layout "admin"

  # GET /admin/media_images
  def index
    @admin_media_images = current_user.church.media_images
  end

  # GET /admin/media_images/1
  def show; end

  # GET /admin/media_images/new
  def new
    @admin_media_image = current_user.church.media_images.new
  end

  # GET /admin/media_images/1/edit
  def edit; end

  # POST /admin/media_images
  def create
    @admin_media_image = current_user.church.media_images.new(admin_media_image_params)

    if @admin_media_image.save
      redirect_to @admin_media_image, notice: 'Media image was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /admin/media_images/1
  def update
    if @admin_media_image.update(admin_media_image_params)
      redirect_to @admin_media_image, notice: 'Media image was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /admin/media_images/1
  def destroy
    @admin_media_image.destroy
    redirect_to admin_media_images_url, notice: 'Media image was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_admin_media_image
    @admin_media_image = current_user.church.media_images.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def admin_media_image_params
    params.require(:admin_media_image).permit(:caption, :image)
  end
end
