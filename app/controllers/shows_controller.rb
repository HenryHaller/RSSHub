class ShowsController < ApplicationController
  before_action :set_show, only: [:show, :destroy]
  def new
    @show = Show.new
  end

  def create
    show = Show.new(show_params)
    if show.save
    current_user.shows << show
      redirect_to shows_path
    else
      render :index
    end
  end

  def index
    @shows = current_user.shows
    @show = Show.new
  end

  def show
  end

  def destroy
    @show.destroy
    redirect_to shows_path
  end

  private

  def show_params
    params.require(:show).permit(:rss_url)
  end

  def set_show
    @show = Show.find(params[:id])
  end
end
