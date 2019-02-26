module V1
  class EpisodesController < ApplicationController
    def index
      @episodes = current_user.episodes.order(pub_date: :desc).first(20)
      json_response(@episodes)
    end
  end
end
