class EpisodesController < ApplicationController
  include Response
  include ExceptionHandler
  def index
    @episodes = Episode.all
    json_response(@episodes)
  end

  private

  # def show_params
  #   params.require(:show).permit(:rss_url)
  # end
end
