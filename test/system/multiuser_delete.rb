require "application_system_test_case"

class MultiuserDelete < ApplicationSystemTestCase
  test "visiting the index" do
    visit "/"
    assert_selector "h4", text: "RSSHub Home"
  end


  def login(user)
    login_as users(user)
    visit episodes_path
    assert_equal episodes_path, page.current_path
  end


  test "unsubscribes from but does not delete a show that also belongs to other users" do
    puts
    puts ">>>>>>>>>>>>>>>>>Running unsubscribes from but does not delete a show that also belongs to other users <<<<<<<<<"
    puts

    rss_url = "http://localhost:3001/feed.rss"

    login(:george)
    fill_in "show_rss_url", with: rss_url
    click_on 'Create Show'
    assert_equal episodes_path, page.current_path
    assert_text "You are now subscribed to Test Feed."
    # save_and_open_screenshot
    visit episodes_path
    # save_and_open_screenshot
    logout

    login(:george)
    # save_and_open_screenshot
    assert_text "Test Feed"
    logout


    login(:sam)
    fill_in "show_rss_url", with: rss_url
    click_on 'Create Show'
    assert_equal episodes_path, page.current_path
    assert_text "You are now subscribed to Test Feed."
    click_on "Delete"
    assert_text "Unsubscribed from Test Feed at #{rss_url}."
    assert_text "episode 5", maximum: 0
    puts "george@abitbol.com shows"
    User.where(email: "george@abitbol.com").first.shows.each {|show| puts show}

    logout

    login(:george)
    # save_and_open_screenshot
    puts "george@abitbol.com shows"
    User.where(email: "george@abitbol.com").first.shows.each {|show| puts show}
    puts "sam@serious.com shows"
    User.where(email: "sam@serious.com").first.shows.each {|show| puts show}
    puts "shows in database: #{Show.count}"
    puts Show.first.users
    # save_and_open_screenshot
    assert_text "Test Feed"
    logout

    login(:sam)
    assert_text "Test Feed", maximum: 0
  end


end
