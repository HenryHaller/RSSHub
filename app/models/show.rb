require "open-uri"
require "rss"
require "EpisodeAccessModule"

class Show < ApplicationRecord
  include EpisodeAccessModule
  validate :can_open_url?, :can_parse_data?, :on => :create
  after_create :update_episodes, :set_self_metadata
  has_many :episodes, dependent: :destroy
  has_and_belongs_to_many :users

  # def episodes_from_newest_to_oldest(limit = nil)
  #   episodes = self.episodes.order(pub_date: :desc)
  #   episodes = episodes.slice(0, limit) if limit.class == Integer && limit <= episodes.length
  #   episodes
  # end

  def get_show_data
    puts "retreiving show data for #{self.title || 'no title'} at #{self.rss_url}"
    begin
      self.data = open(self.rss_url).read
    rescue Errno::ECONNREFUSED => e
      puts e.message
    end
  end

  def set_self_metadata
    if self.title
      puts "updating show set_self_metadata for #{self.title}"
    else
      puts "updating show set_self_metadata for #{self.rss_url}"
    end
    feed = get_feed
    self.title = feed.channel.title
    self.show_img = feed.channel.image.url if feed.channel.image
    self.save
  end

  def update_episodes(first_run = false)
    puts "updating past episodes for #{self.title}" if self.title
    feed = get_feed
    feed.items.each do |episode|
      ep = Episode.new(
        title: episode.title,
        url: episode.enclosure.url,
        duration: episode.enclosure.length,
        description: episode.description,
        pub_date: episode.pubDate,
        show: self
        )
      unless ep.save
        puts ep.errors.messages
        puts "failed to save #{ep.title}"
        break
      else
        if first_run # if this us first run then we don't want to be sending out emails
          puts "first run is true"
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

  def can_open_url?
    puts "running can_open_url?"
    begin
      self.get_show_data
    rescue Errno::ENOENT => e
      $stderr.puts "Caught the exception: #{e}"
      errors.add(:retrieve_data, e)
      # answer =  false
    end
    # puts "validation answer is #{answer}"
    # answer
  end

  def can_parse_data?
    unless self.errors.details.include?(:retrieve_data) # if we already can't load this data then there's no need to see if we can parse it or not
      puts "running can_parse_data"
      begin
        self.get_feed.class
      rescue TypeError => e
        $stderr.puts "Caught the exception: #{e}"
        errors.add(:parse_data, e)
      end
    end
  end

  def get_feed
    if Time.now() - self.updated_at > 1.hours && self.new_record? == false
      self.get_show_data
      self.save
      self.touch
    end
    RSS::Parser.parse(self.data)
  end
end
