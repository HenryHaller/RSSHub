require "open-uri"
require "rss"

class Show < ApplicationRecord
  after_create :get_show_data, :update_episodes, :set_self_metadata
  has_many :episodes
  has_and_belongs_to_many :users

  def get_show_data
    self.data = open(self.rss_url).read
    self.save
  end

  def set_self_metadata
    if self.title
      puts "updating show set_self_metadata for #{self.title}"
    else
      puts "updating show set_self_metadata for #{self.rss_url}"
    end
    feed = get_feed
    self.title = feed.channel.title
    self.show_img = feed.channel.image.url
    self.save
  end

  def update_episodes(first_run = true)
    puts "updating past episodes for #{self.title}" if self.title
    feed = get_feed
    feed.items.each do |episode|
      ep = Episode.new(
        title: episode.title,
        url: episode.enclosure.url,
        duration: episode.enclosure.length,
        show: self
        )
      unless ep.save
        puts ep.errors.messages
        puts ep.title
        break
      else
        unless first_run # if this us first run then we don't want to be sending out emails
          puts "first run is false"
          # self.users.each do |user|
          #   puts "sending email to #{user}"
          #   NewEpisodeMailer.with(user: user, episode: ep).new_episode_email.deliver_now
          # end
        end
      end
    end
  end

  def inspect
    "#{self.title}, #{self.episodes.length} Episodes, #{self.rss_url}"
  end

  private
  def get_feed
    self.get_show_data if Time.now() - self.updated_at > 1.hours
    RSS::Parser.parse(self.data)
  end
end
