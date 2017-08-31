class IndexController < ApplicationController

  def index
    if admin_signed_in?
      return redirect_to base_admin.admin_dashboard_path
    end

    if user_signed_in?
      return redirect_to base_messages.user_dashboard_path
    end
  end

end
