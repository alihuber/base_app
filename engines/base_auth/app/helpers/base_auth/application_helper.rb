module BaseAuth
  module ApplicationHelper
    def login_link
      link_to t("base_auth.helpers.login_link"),
              base_auth.login_path, id: "login_link"
    end

    def logout_link
      link_to t("base_auth.helpers.logout_link"),
              base_auth.logout_path, method: :delete,
              id: "logout_link"
    end
  end
end
