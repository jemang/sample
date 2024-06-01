require "application_responder"

class ApplicationController < ActionController::Base
  include Pagy::Backend

  self.responder = ApplicationResponder
  respond_to :html, :json, :js

  before_action :set_current_report

  helper_method :turbo_frame_request_id
  helper_method :current_report

  def set_current_report
    Current.report ||= DailyRecord.find_or_create_by(date: Time.zone.today.to_date)
  end

  def current_report
    @current_report || Current.report
  end
end
