require "test_helper"

class Api::V1::TasksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:lufi_with_two_tasks)
    @task = tasks(:first_task_lufi)
  end

  test "don't show tasks if the user has wrong token" do
    get api_v1_tasks_url,
      headers: {email: @user.email, token: "wrong token"}
    assert_response :unauthorized
  end

  test "list only tasks that belong to the current user" do
    get api_v1_tasks_url,
      headers: {email: @user.email, token: @user.authentication_token}
    assert_response :success

    json_response = JSON.parse(response.body, symbolize_names: true)

    assert_equal @user.tasks.count, json_response.count
    assert_match tasks(:first_task_lufi).title, response.body
    assert_match tasks(:second_task_lufi).title, response.body
    assert_no_match tasks(:first_task_tobi).title, response.body
  end

  test "show a single task" do
    get api_v1_task_url(@task),
      headers: {email: @user.email, token: @user.authentication_token}
    assert_response :success

    json_response = JSON.parse(response.body, symbolize_names: true)

    assert_equal @task.title, json_response[:title]
    assert_equal @task.description, json_response[:description]
  end

  test "get an error when the task don't exists" do
    get api_v1_task_url("wrong id"),
      headers: {email: @user.email, token: @user.authentication_token}

    json_response = JSON.parse(response.body, symbolize_names: true)

    assert_response :not_found
    assert_equal "Task not found", json_response[:error]
  end

  test "create a task for the current user" do
    user = users(:user_without_tasks)
    task_params = {
      title: "A new one",
      description: "Some description",
      image: fixture_file_upload("lamp.jpg", "image/jpeg")
    }

    assert_difference("Task.count", 1) do
      post api_v1_tasks_url, params: {task: task_params},
        headers: {email: user.email, token: user.authentication_token}
    end
    assert_response :ok

    json_response = JSON.parse(response.body, symbolize_names: true)

    assert_equal 1, user.tasks.count
    assert_equal "A new one", json_response[:title]
    assert_equal "Some description", json_response[:description]
    assert_equal user.id, json_response[:user_id]

    # Test if the image was uploaded correctly
    task_created = Task.find(json_response[:id])

    assert task_created.image.attached?

    get image_api_v1_task_url(task_created),
      headers: {email: user.email, token: user.authentication_token}

    assert_response :success
    assert_equal Mime[:json], response.media_type
  end

  test "don't create an invalid task" do
    user = users(:user_without_tasks)
    task_params = {title: "", description: ""}

    assert_no_difference("Task.count") do
      post api_v1_tasks_url, params: { task: task_params },
        headers: {email: user.email, token: user.authentication_token}
    end
    assert_response :bad_request

    json_response = JSON.parse(response.body, symbolize_names: true)

    assert_equal 0, user.tasks.count
    assert_equal "Unable to save this task", json_response[:error]
  end

  test "create a task without image" do
    task_params = {title: "Without image", description: "Some description"}

    assert_difference("Task.count", 1) do
      post api_v1_tasks_url, params: {task: task_params},
        headers: {email: @user.email, token: @user.authentication_token}
    end
    assert_response :ok

    json_response = JSON.parse(response.body, symbolize_names: true)
    task_created = Task.find(json_response[:id])

    assert_not task_created.image.attached?

    get image_api_v1_task_url(task_created),
      headers: {email: @user.email, token: @user.authentication_token}

    json_response = JSON.parse(response.body, symbolize_names: true)

    assert_response :bad_request
    assert_equal "Unable to display image for this task", json_response[:error]
    assert_equal Mime[:json], response.media_type
  end

  test "destroy a task" do
    assert_difference("Task.count", -1) do
      delete api_v1_task_url(@task),
        headers: {email: @user.email, token: @user.authentication_token}
    end
    assert_response :no_content
  end
end
