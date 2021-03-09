class MemberMailer < ApplicationMailer
  add_template_helper ApplicationHelper

  def event_added
    @user = params[:recipient]
    @event = params[:event]
    mail(to: @user.email, subject: "#{@event.name} added.")
  end

  def event_started
    @user = params[:recipient]
    @event = params[:event]
    mail(to: @user.email, subject: "#{@event.name} started.")
  end
end
