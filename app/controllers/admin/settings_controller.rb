# frozen_string_literal: true
class Admin::SettingsController < ApplicationController

  layout "admin"

  def church_update
    @church = current_user.church
    if @church.update(church_params)
      flash[:notice] = 'Update successful'
      redirect_to settings_profile_path
    else
      flash.now[:error] = @church.errors.full_messages.first
      render 'settings/profile'
    end
  end

  def subdomain_update
    subdomain = params[:user][:subdomain]
    if current_user.subdomain != subdomain
      if User.exists?(subdomain: subdomain)
        current_user.subdomain = subdomain
        current_user.errors.add(:subdomain, 'already exists.')
        render 'settings/profile'
      elsif subdomain.blank?
        current_user.errors.add(:subdomain, 'can\'t be blank.')
        render 'settings/profile'
      else
        User.where(subdomain: current_user.subdomain).update_all(subdomain: subdomain)
        # current_user.update subdomain: subdomain
        sign_out(current_user)
        redirect_to root_url(subdomain: subdomain)
      end
    else
      redirect_to settings_profile_path, notice: 'No changes needed.'
    end
  end

  private

  def church_params
    params.require(:church).permit(
      :logo,
      :name,
      :address,
      :phone_number,
      :fb,
      :youtube,
      :instagram,
      :give_link
    )
  end
end
