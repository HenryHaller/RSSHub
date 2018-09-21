class ShowsController < ApplicationController
  before_action :set_show, only: [:show, :destroy]
  def new
    @show = Show.new
  end

  def create
    result = AddRequest.call(rss_url: show_params[:rss_url], user_id: current_user.id)
    # pp result
    # @show = result.show
    flash[:notice] = result.user_reply
    if result.parseable
      redirect_to episodes_path
    else
      @show = result.show
      @episodes = current_user.from_newest_to_oldest_episodes.limit(20)
      @shows = current_user.shows
      render "episodes/index"
    end
  end

  def index
    redirect_to episodes_path
  end

  def show
    # @show is still set normally by the set_show method
    @episodes = @show.from_newest_to_oldest_episodes
  end

  def destroy
    result = DeleteRequest.call(show: @show, current_user: current_user)
    flash[:notice] = "Unsubscribed from #{@show.title} at #{@show.rss_url}."
    redirect_to episodes_path
  end

  private

  def show_params
    params.require(:show).permit(:rss_url)
  end

  def set_show
    @show = Show.find(params[:id])
  end
end
