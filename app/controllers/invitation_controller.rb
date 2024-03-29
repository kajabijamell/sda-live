# frozen_string_literal: true

class InvitationController < DeviseController
  prepend_before_action :resource_from_invitation_token

  def accept
    @admin
  end

  def complete
    if @admin.update params.require(:admin).permit(:fname, :lname, :password, :subdomain)
      @admin.update invite_token: nil, invite_sent_at: nil, invitation_completed: true
      flash[:notice] = 'Invitation completed please signin.'
      redirect_to new_user_session_url(subdomain: @admin.subdomain)
    else
      flash.now[:error] = @admin.errors.full_messages.first
      render :accept
    end
  end

  private

  def resource_from_invitation_token
    puts params[:invite_token]
    unless params[:invite_token] && @admin = User.find_by_invitation_token(params[:invite_token], true)
      flash[:error] = 'No user with this invitation found.'
      redirect_to root_path
    else
      if @admin.present? && @admin.invitation_completed
        flash[:error] = 'Invitation link already used.'
        redirect_to root_path
      end
    end
  end
end
