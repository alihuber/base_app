module BaseAccount
  module User
    class FindUser < ActiveInteraction::Base
      integer :id

      def execute
        user = BaseAuth::User.find_by_id(id)

        if user
          user
        else
          errors.add(:id, "does not exist")
        end
      end
    end
  end
end
