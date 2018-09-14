class EpisodesController < ApplicationController
  def index
    render json: current_user.episodes
  end
end
