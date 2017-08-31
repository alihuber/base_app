module BaseMessages
  module User
    class DashboardController < ApplicationController
      before_action :login_user

      def index
      end
    end
  end
end

