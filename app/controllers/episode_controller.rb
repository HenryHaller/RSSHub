class EpisodeController < ApplicationController
  def index
    render json: User.shows
  end
end
