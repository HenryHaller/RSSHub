class EpisodesController < ApplicationController
  def index
    # @episodes = current_user.from_newest_to_oldest_episodes(20) # limit = 20
    if stale?(current_user)
      @episodes = current_user.episodes.includes(:show).order(pub_date: :desc).limit(20)
      @show = Show.new
      # @shows = User.find(current_user.id).shows
      @shows = current_user.shows
      # byebug
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @episodes }
      end
    end
  end

  private

  def show_params
    params.require(:show).permit(:rss_url)
  end
end
