module V1
  class EpisodesController < ApplicationController
    def index
      @episodes = Episode.all
      json_response(@episodes)
    end
  end
end
