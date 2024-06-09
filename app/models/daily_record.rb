class DailyRecord < ApplicationRecord
  include Redis::Objects
  by_star_field :date

  default_scope { order(date: :desc) }

  counter :rc_male
  counter :rc_female
  counter :rc_users

  after_commit :calc_average_age

  def self.generate_daily_report(record_date = Time.zone.today.to_date)
    report = find_or_create_by(date: record_date)
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

  def today_report_counter
    previous_record = previous
    return {} if previous_record.nil?

    {
      male: rc_male.value - previous_record.male_count,
      female: rc_female.value - previous_record.female_count
    }
  end
end
