require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @user = FactoryBot.create(:user)
  end

  test "user can authenticate" do
    assert User.authenticate(@user.email, @user.authentication_token)
    assert_not User.authenticate(@user.email, "wrong token")
  end
end
