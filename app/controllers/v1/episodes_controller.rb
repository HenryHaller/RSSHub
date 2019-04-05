module V1
  class EpisodesController < ApplicationController
    def index
      if stale?(etag: current_user, last_modified: current_user.updated_at, public: false)
        page = params[:page]
        @episodes = current_user.episodes.includes(:show).order(pub_date: :desc).page(page)
        json_response(@episodes)
      end
    end
  end
end
