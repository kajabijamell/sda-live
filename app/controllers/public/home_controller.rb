# frozen_string_literal: true

class Public::HomeController < PublicController
  def index
    @events = @church.events
    @sermons = @church.media_sermons
    @news = @church.news
  end
end
