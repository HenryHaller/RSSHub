module V1
  class ShowsController < ApplicationController
    before_action :set_show, only: %i[show destroy]

    def index
      @shows = current_user.shows
      json_response(@shows)
    end

    def create
      @show = current_user.shows.create!(show_params)
      json_response(@show, :created)
    end

    def show
      json_response(@show)
    end

    def destroy
      @show.destroy
      head :no_content
    end

    private

    def show_params
      params.permit(:rss_url)
    end

    def set_show
      @show = Show.find(params[:id])
    end
  end
end
