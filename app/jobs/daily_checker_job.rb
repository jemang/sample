class DailyCheckerJob < ApplicationJob
  queue_as :daily_record
  sidekiq_options retry: false

  def perform
    DailyRecord.generate_daily_report
  end
end
