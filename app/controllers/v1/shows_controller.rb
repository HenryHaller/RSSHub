module V1
  class ShowsController < ApplicationController
    before_action :set_show, only: %i[show destroy]

    def index
      @shows = current_user.shows
      @shows = @shows.map { |show| show_serializer(show) }
      json_response(@shows)
    end

    def create
      url = follow_redirect(show_params[:rss_url])
      @show = Show.find_by(rss_url: url)
      if @show.nil?
        @show = current_user.shows.create!(rss_url: url)
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
      current_user.touch
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
