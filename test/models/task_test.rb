require "test_helper"

class TaskTest < ActiveSupport::TestCase
  setup do
    @user = users(:user_without_tasks)
    @task = @user.tasks.build(title: "First task", description: "Something")
  end

  test "should be valid" do
    assert @task.valid?
  end

  test "title should be present" do
    @task.title = " "
    assert_not @task.valid?
  end

  test "description should be present" do
    @task.description = "   "
    assert_not @task.valid?
  end

  test "description should be at most 80 characters" do
    @task.description = "a" * 81
    assert_not @task.valid?
  end

  test "user_id should be present" do
    @task.user_id = nil
    assert_not @task.valid?
  end
end
