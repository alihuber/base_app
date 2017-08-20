module BaseApi
  class Engine < ::Rails::Engine
    isolate_namespace BaseApi
    config.generators.api_only = true

  end
end
