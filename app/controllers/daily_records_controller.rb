class DailyRecordsController < ApplicationController
  before_action :set_daily_record

  def show
    respond_with(@daily_record)
  end

  private

  def set_daily_record
    @daily_record = DailyRecord.find(params[:id])
  end
end
