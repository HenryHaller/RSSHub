class ShowsController < ApplicationController
  before_action :set_show, only: [:show, :destroy]
  def new
    @show = Show.new
  end

  def create
    show = Show.new(show_params)
    if show.save
      current_user.shows << show
      # @episodes = current_user.episodes.order(pub_date: :desc).limit(15)
      # @shows = current_user.shows
      # @show = Show.new
      # render "episodes/index"
    end
      redirect_to episodes_path
  end

  def index
    @shows = current_user.shows
    @show = Show.new
  end

  def show
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
