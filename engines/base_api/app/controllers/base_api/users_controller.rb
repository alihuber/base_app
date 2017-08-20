module BaseApi
  class UsersController < BaseApi::ApplicationController

    before_action :admin_authenticated?

    def index
      @users = BaseApi::Users::ListUsers.run!
    end

  end
end
