module BaseApi
  class UsersController < BaseApi::ApplicationController

    before_action :admin_authenticated?

    def index
      @users = BaseApi::Users::ListUsers.run!
    end

    def show
      outcome = BaseAccount::User::FindUser.run(params)
      return head 404 unless outcome.valid?
      @user   = outcome.result
    end

    def update
      user    = BaseAccount::User::FindUser.run(params)
      return head 404 unless user.valid?
      inputs  = { user: user.result }.reverse_merge(params[:user])
      outcome = BaseAccount::User::UpdateUser.run(inputs)
      if(outcome.valid?)
        @user = outcome.result if outcome.valid?
        render :show
      else
        render json: { error: outcome.errors }, status: 422
      end
    end

    def destroy
      outcome = BaseApi::Users::DeleteUser.run(params)
      if(outcome.valid?)
        @user = outcome.result if outcome.valid?
        render :show
      else
        head 404
      end
    end
  end
end
