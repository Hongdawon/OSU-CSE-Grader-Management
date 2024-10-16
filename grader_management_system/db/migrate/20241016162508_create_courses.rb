class CreateCourses < ActiveRecord::Migration[7.2]
  def change
    create_table :courses do |t|
      t.string :subject
      t.integer :catalogNumber
      t.string :title
      t.string :term
      t.string :campus
      t.string :description
      t.integer :credits

      t.timestamps
    end
  end
end
