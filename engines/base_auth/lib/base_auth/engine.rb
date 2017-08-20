require "active_interaction"
require "bootstrap_form"

module BaseAuth
  class Engine < ::Rails::Engine
    isolate_namespace BaseAuth

    config.generators do |g|
        g.template_engine     :slim
        g.test_framework      :rspec, fixture: false
        g.controller_specs    false
        g.helper_specs        false
        g.routing_specs       false
        g.view_specs          false
        g.fixture_replacement :factory_girl, dir: "spec/factories"
    end

    # Run migrations in this engine for the main app, too
    initializer "base_auth.append_migrations" do |app|
      unless app.root.to_s.match(root.to_s)
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
    end

    # rake_tasks do
    #   load "#{config.root}/lib/tasks/scheduler.rake"
    # end

    config.to_prepare do
      Rails.application.config.assets.precompile += %w(
        base_auth/loginCtrl.js
        base_auth/requestPasswordResetCtrl.js
        base_auth/editPasswordResetCtrl.js
      )

      ::ApplicationController.class_eval do
        include AuthenticationConcern
        helper BaseAuth::Engine.helpers

        # before_action :initialize_session
      end
    end
  end
end
