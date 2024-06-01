class DailyRecord < ApplicationRecord
  include Redis::Objects

  counter :rc_male
  counter :rc_female
  counter :rc_users

  after_commit :calc_average_age

  def self.generate_daily_report
    report = find_or_create_by(date: Time.zone.today.to_date)
    report.male_count = report.rc_male.value
    report.female_count = report.rc_female.value
    report.save
  end

  def calc_average_age
    return unless saved_change_to_male_count? || saved_change_to_female_count?

    self.male_avg_age = User.male_user.average(:age).to_f.round
    self.female_avg_age = User.female_user.average(:age).to_f.round
    save
  end

  def reset_counter
    rc_male.value = User.male_user.count
    rc_female.value = User.female_user.count
    rc_users.value = User.count
  end
end
