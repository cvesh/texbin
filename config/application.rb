require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Texbin
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Makes the log accessible via Docker
    config.logger = Logger.new(STDOUT)

    # Assets to be precompiled besides application.css and application.js
    config.assets.precompile += %w( error.css )

    # LaTeX default options
    config.latex_default_options = %w(-halt-on-error -shell-restricted)

    # Enable serving of images, stylesheets, and JavaScripts from an asset server.
    config.action_controller.asset_host = ENV["TEXBIN_ASSET_HOST"]

    # TeX processing timeout
    config.process_timeout = ENV.fetch('TEXBIN_PROCESS_TIMEOUT', '5').to_i

    # How the generated PDFs will be stored, only supports :file for now
    config.document_storage = ENV.fetch('TEXBIN_DOCUMENT_STORAGE', 'file').to_sym

    # Where the uploaded documents will be kept
    config.document_upload_dir = ENV.fetch('TEXBIN_DOCUMENT_UPLOAD_DIR', 'uploads/docs')

    # Where the documents are saved to before they're definitely stored
    config.document_upload_cache_dir = ENV.fetch('TEXBIN_DOCUMENT_UPLOAD_CACHE_DIR', 'uploads/tmp')

    # Maximum size for any external file
    config.file_size_limit = ENV.fetch('TEXBIN_FILE_SIZE_LIMIT', '1').to_i.megabyte
  end
end
