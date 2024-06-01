require "application_responder"

class ApplicationController < ActionController::Base
  include Pagy::Backend

  self.responder = ApplicationResponder
  respond_to :html, :json, :js

  helper_method :turbo_frame_request_id
end
