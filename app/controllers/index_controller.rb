class IndexController < ApplicationController

  def index
    if admin_signed_in?
      redirect_to base_admin.admin_dashboard_path
    end
  end

end
