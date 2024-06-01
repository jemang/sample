class User < ApplicationRecord
  include Redis::Objects
  include SearchCop

  # value :male
  # value :female

  scope :male_user, -> { where(gender: "male") }
  scope :female_user, -> { where(gender: "female") }

  validates :uuid, presence: true, uniqueness: true

  jsonb_accessor :extras,
                 email: :string,
                 thumbnail: :string

  after_destroy :regenerate_daily_report

  search_scope :search do
    attributes :gender, :age
    attributes first_name: "name->first"
    attributes last_name: "name->last"
    attributes email: "extras->email"

    options :gender, type: :fulltext
  end

  def fullname
    "#{name["title"]} #{name["first"]} #{name["last"]}"
  end

  def self.generate_random_user
    users = RandomUser.all
    users.results.each do |result|
      processing_user(result)
    end
  rescue => e
    Rails.logger.debug(e)
    puts e
  end

  def self.processing_user(data)
    record = find_or_create_by(uuid: data.login.uuid)
    record.assign_attributes(
      gender: data.gender,
      age: data.dob.age,
      email: data.email,
      thumbnail: data.picture.thumbnail,
      name: data.name,
      location: data.location
    )
    record.save if record.changed?
  end

  def male?
    gender == "male"
  end

  private

  def regenerate_daily_report
    DailyCheckerJob.perform_later
  end
end
