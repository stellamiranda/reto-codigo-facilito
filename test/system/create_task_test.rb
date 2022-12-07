require "application_system_test_case"

class CreateTaskTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    @user = FactoryBot.create(:user)
  end

  test "create" do
    sign_in @user

    visit new_task_path

    title = Faker::Lorem.unique.words.join(" ")
    description = Faker::Lorem.unique.words.join(" ")

    fill_in "task[title]", with: title
    fill_in "task[description]", with: description

    click_on("Crear Tarea")

    assert_text "Task saved!"
    assert_equal description, Task.first.description
  end

  test "we can see validatio errors" do
    sign_in @user

    visit new_task_path

    click_on("Crear Tarea")

    assert_text "Task could not be saved."
    assert_text "Title can't be blank"
    assert_text "Description can't be blank"
  end
end
