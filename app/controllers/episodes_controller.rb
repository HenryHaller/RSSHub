class EpisodesController < ApplicationController
  def index
    @episodes = current_user.episodes.order(pub_date: :desc).limit(15)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @episodes }
    end
  end
end
