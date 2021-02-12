# frozen_string_literal: true

class SettingsController < ApplicationController
  before_action :authenticate_user!

  layout 'admin'

  def profile
    @facebook_stream_accounts = current_user.church.stream_accounts.where(provider: 'facebook').count
    @youtube_stream_accounts = current_user.church.stream_accounts.where(provider: 'google_oauth2').count
  end

  def save_profile
    user = current_user
    if user.update(user_params)
      user.profile_picture_derivatives! if user.profile_picture_changed?
      flash[:success] = 'Profile saved.'
      redirect_to settings_profile_path
    else
      flash.now[:error] = current_user.error.full_messages.first
      render 'settings/profile'
    end
  end

  def destroy
    if current_user.admin?
      user = current_user
      sign_out current_user
      flash[:notice] = 'Account deleted successfully.'
      user.destroy
      redirect_to admin_root_path
    else
      flash[:error] = 'Operation not allowed.'
      redirect_to super_admin_root_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:profile_picture, :fname, :lname, :email, :time_zone)
  end
end
