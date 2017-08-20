module BaseApi
  module Users
    class ListUsers < ActiveInteraction::Base
      def execute
        BaseAuth::User.all
      end
    end
  end
end
