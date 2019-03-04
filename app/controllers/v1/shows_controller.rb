module V1
  class ShowsController < ApplicationController
    before_action :set_show, only: %i[show destroy]

    def index
      @shows = current_user.shows
      json_response(@shows)
    end

    def create
      @show = Show.find_by(show_params)
      if @show.nil?
        @show = current_user.shows.create!(show_params)
        @show.update_episodes
      else
        current_user.shows << @show
      end
      json_response(nil, :created)
    end

    def show
      json_response(@show)
    end

    def destroy
      current_user.shows.delete(@show)
      @show.destroy if @show.users.count.zero?
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
