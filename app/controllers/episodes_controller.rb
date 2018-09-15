class EpisodesController < ApplicationController
  def index
    @episodes = current_user.episodes.order(pub_date: :desc).limit(15)
    @show = Show.new
    @shows = current_user.shows

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @episodes }
    end
  end
end
