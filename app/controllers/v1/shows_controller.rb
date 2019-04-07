module V1
  class ShowsController < ApplicationController
    before_action :set_show, only: %i[show destroy]

    def index
      @shows = current_user.shows
      @shows = @shows.map { |show| show_serializer(show) }
      json_response(@shows)
    end

    def create
      url = show_params[:rss_url]
      url = adapt_soundcloud_url(url) if soundcloud?(url)
      url = follow_redirect(url)
      @show = Show.find_by(rss_url: url)
      if @show.nil?
        @show = current_user.shows.create!(rss_url: url)
        @show.update_episodes
      else
        current_user.shows << @show
      end
      json_response({episodesAdded: @show.episodes.count, showTitle: @show.title}, :created)
    end

    skip_before_action :authorize_request, only: :show
    def show
      page = params[:page]
      @episodes = @show.episodes.order(pub_date: :desc).page(page)
      json_response(@episodes)
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
