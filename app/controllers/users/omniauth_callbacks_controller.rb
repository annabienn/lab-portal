class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    handle_auth("Google")
  end

  def failure
    redirect_to new_user_session_path, alert: "Αποτυχία σύνδεσης."
  end

  private

  def handle_auth(provider_name)
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider_name) if is_navigational_format?
    else
      redirect_to new_user_registration_url, alert: "Δεν ήταν δυνατή η σύνδεση."
    end
  end
end
