class Admin::DashboardController < ApplicationController
  layout "admin"
  
  def index
    @admin_live_streams = current_user.church.live_streams
  end
end
