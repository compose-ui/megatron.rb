require 'rubygems'
require 'bundler/setup'

require 'combustion'
Combustion.initialize! :action_controller, :action_view, :sprockets

require 'rspec/rails'

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
end

module ActionDispatch
  class ExceptionWrapper
    @@rescue_responses.merge!(
        'Megatron::Unauthorized' => :unauthorized,
        'Megatron::Forbidden' => :forbidden
    )
  end
end

def test_request
  if Rails::VERSION::MAJOR >= 5
    ActionDispatch::TestRequest.create
  else
    ActionDispatch::TestRequest.new
  end
end
