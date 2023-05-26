require "test_helper"

class HometeControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get homete_create_url
    assert_response :success
  end
end
