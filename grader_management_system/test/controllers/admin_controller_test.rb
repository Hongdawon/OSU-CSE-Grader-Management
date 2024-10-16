require "test_helper"

class AdminControllerTest < ActionDispatch::IntegrationTest
  test "should get reload" do
    get admin_reload_url
    assert_response :success
  end
end
