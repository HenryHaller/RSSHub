class EpisodesController < ApplicationController
  def index
    @episodes = current_user.from_newest_to_oldest_episodes(limit=20)
    if params[:rss_url]
      @new_show = Show.new(rss_url: params[:rss_url])
      @new_show.errors.add(:rss_url)
    else
      @new_show = Show.new
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @episodes }
    end
  end

  private
  def show_params
    params.require(:show).permit(:rss_url)
  end

end
