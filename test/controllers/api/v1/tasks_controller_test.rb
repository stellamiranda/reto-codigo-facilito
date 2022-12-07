require "test_helper"

class Api::V1::TasksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = FactoryBot.create(:user)
  end

  test "index" do
    FactoryBot.create_list(:task, 2, user: @user)

    non_listed_task = FactoryBot.create(:task)

    get api_v1_tasks_url,
      headers: {email: @user.email, token: @user.authentication_token}

    assert_response :success

    json_response = JSON.parse(response.body)

    assert_equal @user.tasks.size, json_response.size
    assert_no_match non_listed_task.title, response.body
  end

  test "show" do
    task = FactoryBot.create(:task)

    get api_v1_task_url(task),
      headers: {email: @user.email, token: @user.authentication_token}

      assert_response :success

    json_response = JSON.parse(response.body)

    assert_equal task["title"], json_response["title"]
    assert_equal task["description"], json_response["description"]
  end

  test "image" do
    task = FactoryBot.create(:task, user: @user)

    get image_api_v1_task_url(task),
      headers: {email: @user.email, token: @user.authentication_token}

    json_response = JSON.parse(response.body)

    assert_response :bad_request
    assert_equal "Unable to display image for this task", json_response["error"]
  end

  test "response 404 with wrong id" do
    get api_v1_task_url("fake_id"),
      headers: {email: @user.email, token: @user.authentication_token}

    json_response = JSON.parse(response.body)

    assert_equal "Task not found", json_response["error"]
  end

  test "create" do
    user = FactoryBot.create(:user)

    task_params = {
      title: Faker::Lorem.unique.words.join(" "),
      description: Faker::Lorem.unique.words.join(" "),
      image: fixture_file_upload("test-image.jpeg", "image/jpeg", :binary)
    }

    post api_v1_tasks_url, params: {task: task_params},
        headers: {email: user.email, token: user.authentication_token}

    assert_response :created

    json_response = JSON.parse(response.body)

    assert_equal 1, user.tasks.count
    assert_equal task_params[:title], json_response["title"]
    assert_equal task_params[:description], json_response["description"]
    assert_equal user.id, json_response["user_id"]

    task = Task.find(json_response["id"])

    assert task.image.attached?
  end

  test "create with errors" do
    user = FactoryBot.create(:user)
    task_params = {title: "", description: "  "}

    post api_v1_tasks_url, params: { task: task_params },
        headers: {email: user.email, token: user.authentication_token}

    assert_response :unprocessable_entity

    json_response = JSON.parse(response.body)

    assert_equal "Unable to save this task", json_response["error"]
  end

  test "destroy" do
    task = FactoryBot.create(:task, user: @user)

    delete api_v1_task_url(task),
      headers: {email: @user.email, token: @user.authentication_token}

    assert_response :no_content
  end
end
