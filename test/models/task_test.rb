require "test_helper"

class TaskTest < ActiveSupport::TestCase

 test "when the title or description are an empty string, it's normalized to nil" do
    task = FactoryBot.build(:task, title: "", description: "")
    task.validate
    assert_nil task.title
    assert_not task.valid?

    assert_equal "Title can't be blank", task.errors.objects.first.full_message
    assert_equal "Description can't be blank", task.errors.objects.last.full_message
  end

  test "when the title or description are just a lot of spaces, it's normalized to nil" do
    task = FactoryBot.build(:task, title: " ", description: " ")
    task.validate
    assert_nil task.title
    assert_not task.valid?

    assert_equal "Title can't be blank", task.errors.objects.first.full_message
    assert_equal "Description can't be blank", task.errors.objects.last.full_message
  end


  test "the description can have a maximum of 80 characters" do
    task = FactoryBot.build(:task, description: Faker::Lorem.characters(number: 81))
    task.validate
    assert_not task.valid?

    assert_equal "Description is too long (maximum is 80 characters)", task.errors.objects.first.full_message
  end
end
