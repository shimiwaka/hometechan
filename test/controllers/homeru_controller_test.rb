require "test_helper"

class HomeruControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get homeru_create_url
    assert_response :success
  end
end
