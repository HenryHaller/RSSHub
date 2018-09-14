require "open-uri"
require "rss"

class Show < ApplicationRecord
  after_create :update_episodes, :set_self_metadata
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

  def update_episodes
    self.get_show_data if Time.now() - self.updated_at > 1.hours
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
        break
      end
    end
  end

  def inspect
    "#{self.title}, #{self.episodes.length} Episodes, #{self.rss_url}"
  end

  private
  def get_feed
    RSS::Parser.parse(self.data)
  end
end
