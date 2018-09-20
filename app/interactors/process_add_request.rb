class ProcessAddRequest
  include Interactor
  def call
    context.show_already_exists = false       # Assume that we don't already know this show
    context.user_already_subscribed = false   # Assume that the user is not
                                              # already subscribed to this show

    context.show = Show.create(rss_url: context.rss_url)
    puts
    if context.show.errors.include?(:rss_url)
      context.show_already_exists = context.show.errors.details[:rss_url][0][:error] == :taken
    end
    puts
    # context.show_already_exists = true if context.show.errors.details[:rss_url][0][:error] == :taken


    # context.user = User.find(context.user_id)
    # p current_user
  end

end
