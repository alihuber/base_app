module BaseAuth
  class User
    class SessionController < BaseAuth::ApplicationController
      skip_before_action :verify_authenticity_token, only: :destroy

      def new
        # assign BaseAuth::Session::Actions::Create.new
      end


      def create
        # assign BaseAuth::Session::Actions::Create.new

        # submit params[:session] do |success|
        #   if success
        #     login!(@action.form.user, remember_me: @action.form.remember_me)
        #     flash[:notice] = t("flash.user.session.create.success")
        #     redirect_to redirect_url_from_session || redirect_url
        #   else
        #     unless @action.form.errors.any?
        #       flash.now[:alert] = t("flash.user.session.create.failure")
        #     end
        #     render "new"
        #   end
        # end
      end

      def destroy
        # logout!
        # flash[:notice] = t("flash.user.session.destroy.success")
        # redirect_to main_app.root_path
      end

      private
      def redirect_url_from_session
        session.delete(:redirect_url_after_login)
      end

      def redirect_url
        main_app.root_path
      end
    end
  end
end
