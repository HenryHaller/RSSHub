require "open-uri"
require "rss"

class Show < ApplicationRecord
  include UrlSmarts
  validate :looks_like_rss_feed?

  # validate :looks_like_rss_feed?
  validates :rss_url, uniqueness: true
  # validate :can_open_url?, :can_parse_data?, on: :create
  # after_create :set_self_metadata, :update_eipsodes
  has_many :episodes, dependent: :destroy
  has_and_belongs_to_many :users

  # def episodes_from_newest_to_oldest(limit = nil)
  #   episodes = self.episodes.order(pub_date: :desc)
  #   episodes = episodes.slice(0, limit) if limit.class == Integer && limit <= episodes.length
  #   episodes
  # end

  # def fetch_show_data
  #   # puts "retreiving show data for #{self.title || 'no title'} at #{self.rss_url}" if Rails.env == "development" || "test"
  #   begin
  #     self.data = open(self.rss_url).read
  #   rescue Errno::ECONNREFUSED => e
  #     puts e.message
  #   end
  # end

  # def set_self_metadata
  #   feed = self.feed
  #   self.title = feed.title
  #   self.show_img = feed.itunes_image if feed.respond_to?(:itunes_image)
  #   self.save
  # end

  # def update_episodes(first_run = false)
  #   # puts "updating past episodes for #{self.title}" if self.title if Rails.env == "development" || "test"
  #   self.fetch_show_data
  #   self.save
  #   show_updated = false
  #   feed = self.feed
  #   feed.entries.each do |episode|
  #     ep = make_episode(episode)
  #     if ep.save
  #       show_updated = true
  #       # if first_run # if this us first run then we don't want to be sending out emails
  #       #   puts "first run is true"
  #       # end
  #     else
  #       # puts ep.errors.messages
  #       break # stop updating the shows table if one of the show saves fails
  #     end
  #   end
  #   self.users.update_all(updated_at: Time.now) if show_updated
  #   self.touch
  # end

  # def make_episode(episode)
  #   url = episode.entry_id if episode.respond_to?(:entry_id)
  #   url = episode.enclosure_url if episode.respond_to?(:enclosure_url)
  #   duration = 0
  #   duration = episode.enclosure_length if episode.respond_to?(:enclosure_length)
  #   Episode.new(
  #     title: episode.title,
  #     url: url,
  #     duration: duration,
  #     description: episode.summary,
  #     pub_date: episode.published,
  #     show: self
  #   )
  # end

  # def inspect
  #   "#{self.title}, #{self.episodes.length} Episodes, #{self.rss_url}"
  # end

  # def can_open_url?
  #   unless self.errors.details.include?(:rss_url)
  #     # puts "running can_open_url? on #{self.rss_url}" if Rails.env == "development" || "test"
  #     begin
  #       self.fetch_show_data
  #     rescue Errno::ENOENT => e
  #       Rails.logger.warn "Caught the exception: #{e}"
  #       errors.add(:retrieve_data, e)
  #       # answer =  false
  #     end
  #     # puts "validation answer is #{answer}"
  #     # answer
  #   end
  # end

  # def can_parse_data?
  #   unless self.errors.details.include?(:rss_url)
  #     unless self.errors.details.include?(:retrieve_data) # if we already can't load this data then there's no need to see if we can parse it or not
  #       # puts "running can_parse_data on #{self.rss_url}" if Rails.env == "development" || "test"
  #       begin
  #         self.feed
  #       rescue TypeError, RSS::NotWellFormedError => e
  #         Rails.logger.warn "Caught the exception: #{e}"
  #         Rails.logger.warn e.backtrace
  #         errors.add(:parse_data, e)
  #       end
  #     end
  #   end
  # end

  # def feed
  #   feed = Feedjira::Feed.parse self.data
  #   Rails.logger.warn(
  #     "\n                          #{feed.title} is a #{feed.class} with #{feed.entries.count} items         \n"
  #   )
  #   feed
  # end
end
