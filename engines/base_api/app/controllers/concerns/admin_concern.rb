module AdminConcern
  extend ActiveSupport::Concern

  included do
    helper_method :admin_authenticated?
  end

  def admin_authenticated?
    unless @current_user.type == BaseAuth::User::AdminUser.to_s
      render status: :unauthorized
    end
  end


end
