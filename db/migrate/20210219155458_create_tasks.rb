class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.integer :user_id

      t.timestamps
      # created_at date
      # updated_at date
    end
  end
end
