class DailyRecord < ApplicationRecord
  after_commit :calc_average_age

  def self.generate_daily_report
    report = find_or_create_by(date: Time.zone.today.to_date)
    report.male_count = User.male_user.count
    report.female_count = User.female_user.count
    report.save
  end

  def calc_average_age
    return unless saved_change_to_male_count? || saved_change_to_female_count?

    self.male_avg_age = User.male_user.average(:age).to_f.round
    self.female_avg_age = User.female_user.average(:age).to_f.round
    save
  end
end
