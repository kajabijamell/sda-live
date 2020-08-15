# frozen_string_literal: true
class Admin::WebsiteController < ApplicationController
  layout "admin"

  def show
    @website = current_user.church.website
  end

  def edit
    @website = current_user.church.website || Admin::Website.new
  end

  def update
    subdomain = website_params[:subdomain]
    @website = current_user.church.website
    unless @website.present?
      @website = Admin::Website.new(church: current_user.church)
    end
    if @website.update(website_params)
      if current_user.subdomain != subdomain
        if User.exists?(subdomain: subdomain)
          @website.subdomain = subdomain
          @website.errors.add(:subdomain, 'already exists.')
          render 'admin/website/edit'
        else
          User.where(subdomain: current_user.subdomain).update_all(subdomain: subdomain)
          # current_user.update subdomain: subdomain
          sign_out(current_user)
          redirect_to root_url(subdomain: subdomain)
        end
      else
        redirect_to admin_root_path, notice: 'Saved website config.'
      end
    else
      render 'admin/website/edit'
    end
  end

  private

  def website_params
    params.require(:admin_website).permit(:primary_color, :heading_font, :body_font, :youtube_live, :hero_image, :subdomain)
  end
end
