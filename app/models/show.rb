require "open-uri"
require "rss"

class Show < ApplicationRecord
  validate :can_open_url?, :can_parse_data?
  after_create :update_episodes, :set_self_metadata
  # validates :rss_url, url: { no_local: true, schemes: ['https', 'http']  }
  has_many :episodes, dependent: :destroy
  has_and_belongs_to_many :users

  def get_show_data
    puts "retreiving show data for #{self.title}"
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
    puts "running can_get_feed?"
    begin
      puts "inside of the begin"
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
    puts "running can_parse_data"
    begin
      self.get_feed.class
    rescue TypeError => e
      $stderr.puts "Caught the exception: #{e}"
      # puts e.backtrace
      errors.add(:parse_data, e)
      raise
    end
  end

  def get_feed
    puts self.new_record?
    unless self.new_record?
      "We are now going to check this record's time stamp to see if we should hit the server"
      self.get_show_data if Time.now() - self.updated_at > 1.hours
      self.touch
    end
    RSS::Parser.parse(self.data)
  end
end
