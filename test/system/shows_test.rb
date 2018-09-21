require "application_system_test_case"

class ShowsTest < ApplicationSystemTestCase
  test "visiting the index" do
    visit "/"
    assert_selector "h4", text: "RSSHub Home"
  end


  def login(user)
    login_as users(user)
    visit episodes_path
    assert_equal episodes_path, page.current_path
  end

  test "lets a new user create and delete a new show" do
    rss_url = "http://localhost:3001/feed.rss"
    login(:george)
    # save_and_open_screenshot

    fill_in "show_rss_url", with: rss_url
    # save_and_open_screenshot

    click_on 'Create Show'
    assert_text "You are now subscribed to Test Feed."
    # save_and_open_screenshot

    # puts
    # puts page.current_path
    # puts

    fill_in "show_rss_url", with: rss_url
    # save_and_open_screenshot

    click_on 'Create Show'

    # puts
    # puts page.current_path
    # puts
    # save_and_open_screenshot
    assert_text "You are already subscribed to #{rss_url} as Test Feed."

    # Should be redirected to Home with new product
    assert_text "Episodes"
    click_on 'Delete'

    assert_text "Unsubscribed from Test Feed at #{rss_url}."
    assert_text "test podcast 1", maximum: 0
    # assert_text "Test Feed", maximum: 0
    assert_equal episodes_path, page.current_path

    # save_and_open_screenshot
  end

  test "does not add a malformed url" do
    rss_url = "asdf"
    login(:george)
    fill_in "show_rss_url", with: rss_url
    # save_and_open_screenshot

    click_on 'Create Show'
    # save_and_open_screenshot

    # puts
    # puts page.current_path
    # puts

    assert_text "The feed at #{rss_url} was not retrievable."
    # save_and_open_screenshot
  end

  test "does not add an un parseable url" do
    rss_url = "https://www.perdu.com/"
    login(:george)
    fill_in "show_rss_url", with: rss_url
    # save_and_open_screenshot

    click_on 'Create Show'
    # save_and_open_screenshot

    # puts
    # puts page.current_path
    # puts

    assert_text "The feed at #{rss_url} was not parseable."
    # save_and_open_screenshot
  end


end
