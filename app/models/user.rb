class User < ApplicationRecord
  validates :uuid, presence: true, uniqueness: true

  jsonb_accessor :extras,
    email: :string,
    thumbnail: :string

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
end