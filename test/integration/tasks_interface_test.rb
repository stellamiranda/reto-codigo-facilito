require "test_helper"

class TasksInterfaceTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:lufi_with_two_tasks)
    @task = tasks(:first_task_lufi)
  end

  test "list all task for the current user" do
    sign_in @user
    get tasks_path

    assert_response :success
    assert_select "h1", "Task Index"
    @user.tasks.each { |task| assert_match task.title, response.body }
    assert_no_match tasks(:first_task_tobi).title, response.body
  end

  test "show correctly a task" do
    sign_in @user
    get task_path(@task)

    assert_response :success
    assert_select "h3", "Task Details"
    assert_match @task.title, response.body
    assert_match @task.description, response.body
  end

  test "create a task for the current user" do
    sign_in users(:user_without_tasks)
    tasks_params = {
      title: "My first task",
      description: "My description for my task"
    }
    get new_task_path

    assert_response :success
    assert_select "h2", "Create task"

    # Valid submission
    assert_difference("Task.count", 1) do
      post tasks_path, params: {task: tasks_params}
    end
    assert_redirected_to tasks_path
    assert_equal "Task saved!", flash[:notice]

    get tasks_path

    assert_match "My first task", response.body
    assert_match "My description for my task", response.body

    # Invalid submission
    assert_no_difference("Task.count") do
      post tasks_path, params: {task: {title: "", description: ""}}
    end
    assert_match "Task could not be saved.", flash[:alert]
    assert_select "h2", "Create task"
  end

  test "destroy a task" do
    sign_in @user
    get tasks_path

    assert_select "a[href*='/#{@task.id}']", text: "Delete"
    assert_select "a", text: "Delete", count: 2

    assert_difference("Task.count", -1) do
      delete task_path(@task)
    end
    assert_redirected_to tasks_path
    assert_equal "Task destroyed!", flash[:notice]

    get tasks_path

    assert_select "a", text: "Delete", count: 1
    assert_select "a[href*='/#{@task.id}']", text: "Delete", count: 0
  end
end
