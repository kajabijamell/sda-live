class Admin::OmniauthController < Devise::OmniauthCallbacksController
  def facebook
    stream_account = Admin::StreamAccount.from_omniauth(auth_hash, current_user)
    if stream_account.persisted?
      flash[:notice] = 'Connected facebook successfully.'
    else
      flash[:error] = stream_account.errors.full_messages.first || 'Something went wrong'
    end
    redirect_to settings_profile_path
  end

  def google_oauth2
    stream_account = Admin::StreamAccount.from_omniauth(auth_hash, current_user)
    if stream_account.persisted?
      flash[:notice] = 'Connected google successfully.'
    else
      flash[:error] = stream_account.errors.full_messages.first || 'Something went wrong'
    end
    redirect_to settings_profile_path
  end

  def failure
    redirect_to admin_root_path
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
