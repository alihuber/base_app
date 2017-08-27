module BaseApi
  module Users
    class DeleteUser < ActiveInteraction::Base
      integer :id

      def execute
        user = BaseAuth::User.find_by_id(id)

        if user
          user.destroy
        else
          errors.add(:id, "does not exist")
        end
      end
    end
  end
end
