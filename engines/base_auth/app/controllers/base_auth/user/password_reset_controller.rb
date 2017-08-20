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
        @form = NewPasswordReset.run!
      end


      def update
        if params[:user_new_password_reset_password_reset]
          password =
            params[:user_new_password_reset_password_reset][:password]
        else
          password = params[:user_update_password][:password]
        end
        token      = params[:token]
        inputs     = Hash[password: password, token: token]
        reset_form = UpdatePassword.run(inputs)
        if reset_form.valid?
          flash[:notice] = t("flash.user.password_reset.edit.success")
          redirect_to main_app.root_path
        else
          @form = reset_form
          flash.now[:alert] = t("flash.user.password_reset.edit.failure")
          render "edit"
        end
      end
    end
  end
end
