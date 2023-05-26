require "test_helper"

class StaticControllerTest < ActionDispatch::IntegrationTest
  test "should get policy" do
    get static_policy_url
    assert_response :success
  end
end
