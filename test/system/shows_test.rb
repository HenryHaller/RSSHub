require "application_system_test_case"

class ShowsTest < ApplicationSystemTestCase
  test "visiting the index" do
    visit "/"
    assert_selector "h4", text: "RSSHub Home"
  end
end
