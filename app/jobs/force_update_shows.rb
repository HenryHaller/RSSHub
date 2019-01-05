class ForceUpdateShowsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Show.all.each { |show| show.update_episodes(false) } # set first_run to false
    # Do something later
  end
end
