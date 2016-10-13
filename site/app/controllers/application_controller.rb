class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # Allow navigation to expect current_account to exist
  helper_method :current_account

  def current_account
    Struct.new(:slug).new('dummy-account')
  end
end
