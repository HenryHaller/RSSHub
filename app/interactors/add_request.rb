class AddRequest
  include Interactor
  def call
    context.show_already_in_database = false       # Assume that we don't already know this show
    context.user_already_subscribed = false        # Assume that the user is not
                                                   # already subscribed to this show

   context.retrievable = true                      # Assume we can retrieve data
   context.parseable = true                        # Assume we can parse the retrieve data


   context.user_reply = "You are now subscribed to %{title}."
    #use the show validation to see if we already track this show or not
    context.show = Show.create(rss_url: context.rss_url)
    if context.show.errors.include?(:rss_url)
      context.show_already_in_database = context.show.errors.details[:rss_url][0][:error] == :taken
      context.show = Show.where(rss_url: context.rss_url).first
    end

    if context.show.errors
      if context.show.errors.include?(:retrieve_data)
        p context.retrievable = false
      end

      if context.show.errors.include?(:parse_data)
        p context.parseable = false
      end
    end

    context.user = User.find(context.user_id)

    context.user_already_subscribed = context.user.shows.any? { |show| show.rss_url == context.rss_url }
    context.user.shows << context.show unless context.user_already_subscribed

    if context.user_already_subscribed
      context.user_reply = "You are already subscribed to #{context.show.rss_url} as #{context.show.title}."
    elsif !context.retrievable
      context.user_reply = "The feed at #{context.show.rss_url} was not retrievable."
    elsif !context.parseable
      context.user_reply = "The feed at #{context.show.rss_url} was not parseable."
    else
      context.user_reply = context.user_reply % {title: context.show.title}
    end

  end

end
