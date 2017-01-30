require File.expand_path('../boot', __FILE__)

require 'rails'
# Pick the frameworks you want:
require 'action_controller/railtie'
require 'action_view/railtie'
require 'autoprefixer-rails'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require 'megatron'

module Site
  class Application < Cyborg::Application
  end
end
