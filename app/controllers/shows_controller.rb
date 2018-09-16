class ShowsController < ApplicationController
  before_action :set_show, only: [:show, :destroy]
  def new
    @show = Show.new
  end

  def create
    @new_show = Show.new(show_params)
    if @new_show.save
      current_user.shows << @new_show
      # @episodes = current_user.episodes.order(pub_date: :desc).limit(15)
      # @shows = current_user.shows
      # @show = Show.new
      # render "episodes/index"
    else
      @episodes = current_user.from_newest_to_oldest_episodes.limit(20)
      render "episodes/index"
    end
  end

  def index
    redirect_to episodes_path
  end

  def show
    # @show is still set normally by the set_show method
    @episodes = @show.from_newest_to_oldest_episodes
    @new_show = Show.new
  end

  def destroy
    @show.destroy
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
