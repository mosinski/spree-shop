require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

module SpreeShop
  class Application < Rails::Application
    
    config.to_prepare do
      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end

      Dir.glob(File.join(File.dirname(__FILE__), "../app/overrides/*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    config.assets.initialize_on_precompile = false
    I18n.enforce_available_locales = false
    config.assets.version = '1.0'
    config.assets.enabled = true
    config.time_zone = 'Warsaw'
    config.encoding = "utf-8"

    config.i18n.default_locale = :en
  end
end
