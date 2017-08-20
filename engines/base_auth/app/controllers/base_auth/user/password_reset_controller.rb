module BaseAuth
  class User
    class PasswordResetController < BaseAuth::ApplicationController

      def new
        @form = RequestPasswordReset.run!
      end


      def create
        inputs =
          params[:user_request_password_reset_password_reset]
        request_form =
          CreateRequestPasswordReset.run(inputs)
        if request_form.valid?
          flash[:notice] =
            t("flash.user.request_password_reset.create.success_html",
            email: request_form.email).html_safe
          redirect_to main_app.root_path
        else
          flash.now[:alert] =
            t("flash.user.request_password_reset.create.failure")
          @form = RequestPasswordReset.run!
          render "new"
        end
      end


      def edit
        @form = EditPasswordReset.run!
      end


      def update
        password =
          params[:user_edit_password_reset_password_reset][:password]
        token    = params[:token]
        inputs   = Hash[password: password, token: token]
        reset    = ResetPassword.run(inputs)
        if reset.valid?
          flash[:notice] = t("flash.user.password_reset.edit.success")
          redirect_to main_app.root_path
        else
          @form = EditPasswordReset.run!
          flash.now[:alert] = t("flash.user.password_reset.edit.failure")
          render "edit"
        end
      end
    end
  end
end
