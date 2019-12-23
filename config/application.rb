require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MorningActivity
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Railsの言語設定
    config.i18n.default_locale = :ja

    # Railsが表示の際に扱うタイムゾーン
    config.time_zone = "Tokyo"

    # DBの読み書きの際に扱うタイムゾーン
    config.active_record.default_timezone = :local

    # ジェネレーターファイル作成制限
    config.generators do |g|
      g.test_framework false
      g.assets false
      g.skip_routes true
      g.helper false
    end
  end
end
