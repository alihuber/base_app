module BaseAdmin
  module Admin
    class DashboardController < ApplicationController

      before_action :login_admin

      def index
      end

    end
  end
end
