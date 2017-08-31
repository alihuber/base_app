module BaseAdmin
  module Admin
    class DashboardController < ApplicationController

      before_action :login_admin

      def index
      end

      def publish_message
        ActionCable.server.broadcast "messages",
          message: params[:content]
        head :ok
      end

    end
  end
end
