class UpdateShowsJob < ApplicationJob
  queue_as :default

  def perform(force = false, *args)
    Show.all.each { |show| show.fetch_show_data } if force
    Show.all.each { |show| show.update_episodes(false) } # first run set to false
    # Do something later
  end
end
