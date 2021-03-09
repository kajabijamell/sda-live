# frozen_string_literal: true

class Public::EventsController < PublicController
  def index
    @events = @church.events.kept
  end

  def show
    @event = @church.events.kept.find(params[:id])
  end
end
