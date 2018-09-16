class UpdateShowsJob < ApplicationJob
  queue_as :default

  def perform(force=false, *args)
    Show.all.each { |show| show.get_show_data } if force
    Show.all.each { |show| show.update_episodes(first_run = false)}
    # Do something later
  end
end
