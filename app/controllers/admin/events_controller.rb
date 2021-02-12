# frozen_string_literal: true
class Admin::EventsController < ApplicationController
  before_action :set_admin_event, only: %i[show edit update destroy]
  before_action :set_time_zone, except: :destroy

  layout "admin"

  # GET /admin/events
  def index
    @admin_events = current_user.church.events.kept
  end

  # GET /admin/events/1
  def show; end

  # GET /admin/events/new
  def new
    @admin_event = current_user.church.events.new
    @stream_accounts = current_user.church.stream_accounts
  end

  # GET /admin/events/1/edit
  def edit; end

  # POST /admin/events
  def create
    @admin_event = current_user.church.events.new(create_admin_event_params)

    if @admin_event.save
      if @admin_event.is_live_stream
        stream_account_ids = params[:admin_event][:event_stream_account_ids]
        AdminEventLiveStreamJob.perform_later(@admin_event.id, stream_account_ids) if stream_account_ids.present?
      end
      redirect_to @admin_event, notice: 'Event was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /admin/events/1
  def update
    if @admin_event.update(update_admin_event_params)
      AdminEventLiveStreamUpdateJob.perform_later(@admin_event.id)
      redirect_to @admin_event, notice: 'Event was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /admin/events/1
  def destroy
    AdminEventLiveStreamDiscardJob.perform_later(@admin_event.id) if @admin_event.is_live_stream
    @admin_event.discard
    redirect_to admin_events_url, notice: 'Event was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_admin_event
    @admin_event = current_user.church.events.kept.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def create_admin_event_params
    params.require(:admin_event).permit(:name, :start_datetime, :end_datetime, :location, :address,
                                        :description, :link, :image, :is_live_stream, :published)
  end

  def update_admin_event_params
    params.require(:admin_event).permit(:name, :start_datetime, :end_datetime, :location, :address,
                                        :description, :link, :image, :published)
  end

  def set_time_zone
    Time.zone = current_user.time_zone || 'Pacific Time (US & Canada)'
  end
end
