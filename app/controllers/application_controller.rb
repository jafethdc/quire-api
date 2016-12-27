require 'koala'

class ApplicationController < ActionController::API
  include Authenticable
  include Error::ErrorHandler
  include Helpers
end
