module V1
  class NotificationSubscriptionsController < ApplicationController
    def update
      show_id = params[:show_id]
      subscribed = params[:subscribed]
      ns = NotificationSubscription.find_by(user_id: current_user.id, show_id: show_id)
      ns.subscribed = subscribed
      ns.save!
      json_response(nil, 201)
    end
  end
end