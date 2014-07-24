module Cms
  class Engine < ::Rails::Engine
    isolate_namespace Cms
    config.to_prepare do
      Dir.glob(Rails.root + "app/decorators/**/*.rb").each do |c|
        require_dependency(c)
      end
    end
  end
end
