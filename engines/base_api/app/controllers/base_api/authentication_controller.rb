module BaseApi
  class AuthenticationController < BaseApi::ApplicationController
    skip_before_action :authenticate_request

    def authenticate
      action =
        BaseAuth::User::Authenticate.run(params[:authentication])

      if action.valid?
        render json: { auth_token: action.result }
      else
        render json: { error: action.errors }, status: :unauthorized
      end
    end
  end
end
