# frozen_string_literal: true

class SettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_subscription_profile

  layout 'admin'

  def profile
    @cards = if @subscription_profile.present? && @subscription_profile.stripe_customer_id.present?
      response = Stripe::GetCards.call(stripe_customer_id: @subscription_profile.stripe_customer_id)
      response.cards.data
    else
      []
    end
    @subscription = if @subscription_profile.present? && @subscription_profile.stripe_subscription_id.present?
      response = Stripe::GetSubscription.call(stripe_subscription_id: @subscription_profile.stripe_subscription_id)
      response.subscription
    else
      []
    end
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

  def load_subscription_profile
    @subscription_profile = current_user.subscription_profile
  end
  
end
