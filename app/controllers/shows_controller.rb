class ShowsController < ApplicationController
  before_action :set_show, only: %i[show destroy]

  def index
    @shows = current_user.shows
    json_response(@shows)
  end

  def create
    @show = current_user.shows.create!(show_params)
    json_response(@show, :created)

    # result = AddRequest.call(rss_url: show_params[:rss_url], user_id: current_user.id)
    # flash[:notice] = result.user_reply
    # if result.parseable
    #   current_user.touch
    #   redirect_to episodes_path
    # else
    #   @show = result.show
    #   @episodes = current_user.episodes.includes(:show).order(pub_date: :desc).limit(20)
    #   @shows = current_user.shows
    #   render "episodes/index"
    # end
  end

  def show
    json_response(@show)
  end


  # def show
  #   # @show is still set normally by the set_show method
  #   @episodes = @show.from_newest_to_oldest_episodes
  #   @shows = current_user.shows
  # end

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
