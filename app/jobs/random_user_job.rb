class RandomUserJob < ApplicationJob
  queue_as :random_record
  sidekiq_options retry: false

  def perform
    User.generate_random_user
  end
end
