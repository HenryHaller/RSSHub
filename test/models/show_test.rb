require 'test_helper'

class ShowTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "fails to lookup as it should" do
    show = Show.new(rss_url: "asdf")
    show.valid?
    assert_includes(show.errors, :retrieve_data, "the errors correctly include the :retrieve_data error" )
  end
  test "fails to parse as it should" do
    show = Show.new(rss_url: "https://www.perdu.com/")
    show.valid?
    assert_includes(show.errors, :parse_data, "the errors correctly include the :parse_data error" )
  end


  test "a well formed but unresponsive url be handled" do
    assert_nothing_raised do
      show = Show.new(rss_url: "http://localhost:3001/feed")
      show.save
    end
  end
end
