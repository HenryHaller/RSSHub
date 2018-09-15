class UpdateShowsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Show.all.each { |show|  show.update_episodes(first_run = false)}
    # Do something later
  end
end
