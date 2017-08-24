module BaseApi
  class ApplicationController < ActionController::API
    before_action :authenticate_request
    include AdminConcern

    private
    def authenticate_request
      token         = request.headers["Authorization"] || {}
      @current_user = BaseAuth::User::AuthorizeApiRequest.run(
        {"headers" => {"Authorization" => token}}
      ).result
      render json: { error: "Not Authorized" }, status: 401 unless @current_user
    end
  end
end
