require 'uri'
require 'nokogiri'
require 'open-uri'

class AddRequest
  include Interactor

  def soundcloud_homepage?(rss_url)
    uri = URI(rss_url)
    if uri.host == "soundcloud.com"
      is_soundcloud_homepage = true
    else
      is_soundcloud_homepage = false
    end
    Rails.logger.warn("#{rss_url} is a soundcloud_homepage") if is_soundcloud_homepage
    is_soundcloud_homepage
  end

  def generate_rss_url_from_soundcloud_homepage(home_page_url)
    valid_metas = %w[twitter:app:url:iphone twitter:app:url:googleplay twitter:app:url:ipad al:ios:url al:android:url]
    noko = Nokogiri::HTML(open(home_page_url))
    property_metas = noko.search("meta[property]")
    id_metas = property_metas.select { |meta| valid_metas.include? meta.attributes["property"].value}
    Rails.logger.warn(noko)
    id_array = id_metas.map { |meta| /[0-9]+/.match(meta.attributes["content"].value)}
    id_array = id_array.uniq
    # to do: raise error if there is more than one id in the mix
    soundcloud_id = id_array[0].to_s
    "http://feeds.soundcloud.com/users/soundcloud:users:#{soundcloud_id}/sounds.rss"
  end

  def call
    context.show_already_in_database = false       # Assume that we don't already know this show
    context.user_already_subscribed = false        # Assume that the user is not already subscribed to this show

    context.retrievable = true                      # Assume we can retrieve data
    context.parseable = true                        # Assume we can parse the retrieve data

    context.user = User.find(context.user_id)

    if soundcloud_homepage?(context.rss_url)
      context.rss_url = generate_rss_url_from_soundcloud_homepage(context.rss_url)
    end

    if context.user.already_subscribed?(context.rss_url)
      context.show_already_in_database = true
      context.user_already_subscribed = true
      context.show = Show.where(rss_url: context.rss_url).first
      context.user_reply = "You are already subscribed to #{context.show.rss_url} as #{context.show.title}."
      return
    end


    context.user_reply = "You are now subscribed to %{title}."
    # use the show validation to see if we already track this show or not
    context.show = Show.create(rss_url: context.rss_url)
    if context.show.errors.include?(:rss_url)
      if context.show.errors.details[:rss_url][0][:error] == :taken
        context.show = Show.where(rss_url: context.rss_url).first
        context.user.shows << context.show
        context.user_reply = format(context.user_reply, title: context.show.title)
      else
        puts "Some weird rss_url error happened"
        context.fail!
      end
      return
    end

    if context.show.errors
      if context.show.errors.include?(:retrieve_data)
        context.retrievable = false
        context.parseable = false
      end

      if context.show.errors.include?(:parse_data)
        context.parseable = false
      end
    end

    if !context.retrievable
      context.user_reply = "The feed at #{context.show.rss_url} was not retrievable."
      return
    elsif !context.parseable
      context.user_reply = "The feed at #{context.show.rss_url} was not parseable."
      return
    else
      context.user.shows << context.show
      context.user.shows
      context.user_reply = format(context.user_reply, title: context.show.title)
    end
  end
end
