class DashboardsController < ApplicationController

  def index
    @reports = DailyRecord.order(date: :desc).limit(5)
  end
end
