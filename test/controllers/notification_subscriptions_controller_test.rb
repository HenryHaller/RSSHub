require 'test_helper'

class NotificationSubscriptionsControllerTest < ActionDispatch::IntegrationTest
  test "should get update" do
    get notification_subscriptions_update_url
    assert_response :success
  end

end
