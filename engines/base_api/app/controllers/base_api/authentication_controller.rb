module BaseApi
  class AuthenticationController < BaseApi::ApplicationController
    skip_before_action :authenticate_request

    def authenticate
      unless params[:authentication]
        return render json: {"error":["authentication failed"]},
          status: :unauthorized
      end
      action =
        BaseAuth::User::AuthenticateApiUser.run(params[:authentication])

      if action.valid?
        render json: { auth_token: action.result }
      else
        render json: { error: action.errors }, status: :unauthorized
      end
    end
  end
end
