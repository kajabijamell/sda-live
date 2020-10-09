# frozen_string_literal: true

class PublicController < ActionController::Base
  before_action :get_church
  layout 'public'

  private

  def get_church
    user = User.find_by_subdomain(request.subdomain)
    if user.present?
      @church = user.church
    else
      # flash[:error] = 'Invalid url'
      redirect_to root_url(subdomain: 'www')
    end
  end
end
