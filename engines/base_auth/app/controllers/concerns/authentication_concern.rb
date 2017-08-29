module AuthenticationConcern
  extend ActiveSupport::Concern


  included do
    helper_method :current_user

    # needed for friendly forwarding/before filter in controllers
    helper_method :admin_signed_in?
    helper_method :user_signed_in?
    helper_method :login_user
    helper_method :login_admin
  end


  def login!(user, remember_me: false)
    if remember_me
      cookies.permanent[:auth_token] = user.auth_token
    else
      cookies[:auth_token] = user.auth_token
    end
  end


  def logout!
    cookies.delete(:auth_token)
  end


  def login_user
    unless user_signed_in?
      session["redirect_url_after_login"] = request.original_url

      flash.alert = t "flash.user.authentication.not_logged_in"
      redirect_to base_auth.login_path
    end
  end


  def login_admin
    unless admin_signed_in?
      session["redirect_url_after_login"] = request.original_url

      flash.alert = t "flash.admin.authentication.not_logged_in"
      redirect_to base_auth.login_path
    end
  end


  def user_signed_in?
    !!current_user
  end


  def admin_signed_in?
    current_user && current_user.admin?
  end


  def current_user
    if cookies[:auth_token]
      @current_user ||=
        BaseAuth::User.find_by(auth_token: cookies[:auth_token])
    end
  end
end
