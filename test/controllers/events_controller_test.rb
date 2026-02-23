require "test_helper"

class EventsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get events_url
    assert_response :success
  end

  test "should get show" do
    get event_url(events(:one))
    assert_response :success
  end

  test "should redirect new to login when not signed in" do
    get new_event_url
    assert_redirected_to new_user_session_path
  end
end
