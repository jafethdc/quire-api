require 'koala'

class ApplicationController < ActionController::API
  include Authenticable
  include Error::ErrorHandler
end
