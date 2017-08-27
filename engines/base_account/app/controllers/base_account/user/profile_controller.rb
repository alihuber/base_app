module BaseAccount
  module User
    class ProfileController < BaseAccount::ApplicationController

      before_action :login_user

      def show
        @form = find_user!
      end

      def update
        inputs  = { user: find_user! }.reverse_merge(params[:user])
        outcome = UpdateUser.run(inputs)

        if outcome.valid?
          flash[:notice] = t("flash.profile.update.success")
          redirect_to(profile_path(outcome.user.id))
        else
          flash.now[:alert] = t("flash.profile.update.failure")
          @form = find_user!
          render(:show)
        end
      end

      private

      def find_user!
        outcome = FindUser.run(params)

        if outcome.valid?
          outcome.result
        else
          raise ActionController::RoutingError.new("Not Found")
        end
      end
    end
  end
end
