require "test_helper.rb"

class Api::AuthenticationTest < ActionDispatch::IntegrationTest
  test "without an email and password, we get a 401" do
    task = FactoryBot.create(:task)

    get api_v1_task_path(task),
      headers: {
        "Accept" => "application/json",
      }

    assert_response 401
  end
end
