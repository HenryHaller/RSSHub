class AddRequest
  include Interactor
  def call
    context.show_already_in_database = false       # Assume that we don't already know this show
    context.user_already_subscribed = false        # Assume that the user is not already subscribed to this show

    context.retrievable = true                      # Assume we can retrieve data
    context.parseable = true                        # Assume we can parse the retrieve data

    context.user = User.find(context.user_id)

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
