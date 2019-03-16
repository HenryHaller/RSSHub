module V1
  class EpisodesController < ApplicationController
    def index
      @episodes = current_user.episodes.includes(:show).order(pub_date: :desc).first(15)
      json_response(@episodes)
    end
  end
end
