require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get status" do
    get users_status_url
    assert_response :success
  end
end
