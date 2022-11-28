require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:user_without_tasks)
  end

  test "authenticate token" do
    assert User.authenticate(@user.email, @user.authentication_token)
    assert_not User.authenticate(@user.email, "wrong token")
  end
end
