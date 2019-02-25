class UpdateShowsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Show.all.each { |show| show.update_episodes} # first run set to false
    Show.all.each(&:update_episodes)
    # Do something later
  end
end
