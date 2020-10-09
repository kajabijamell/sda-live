# frozen_string_literal: true

class Public::HomeController < PublicController
  def index
    @events = @church.events
  end
end
