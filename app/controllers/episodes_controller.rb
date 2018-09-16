class EpisodesController < ApplicationController
  def index
    @episodes = current_user.from_newest_to_oldest_episodes(limit=20)
    @new_show = Show.new

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @episodes }
    end
  end
end
