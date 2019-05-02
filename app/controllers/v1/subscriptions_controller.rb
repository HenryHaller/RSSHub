module V1
  class SubscriptionsController < ApplicationController
    def create
      begin
        endpoint = params[:endpoint]
        auth = params[:keys][:auth]
        p256dh = params[:keys][:p256dh]
        current_user.subscriptions.create!(endpoint: endpoint, auth: auth, p256dh: p256dh)
        json_response(nil, 201)
      rescue ActiveRecord::RecordInvalid => e
        Rails.logger.warn(e.message)
        Rails.logger.warn(e.class)
        json_response(nil, 409)
      end
    end
  end
end