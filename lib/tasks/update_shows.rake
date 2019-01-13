namespace :update_shows do
  task update: :environment do
    UpdateShowsJob.perform_now
    # Show.all.each { |show| show.fetch_show_data }
    # Show.all.each { |show| show.update_episodes(false) } # first run set to false
  end
end
