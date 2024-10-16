class ChangeCatalogNumberToBeStringInCourses < ActiveRecord::Migration[7.2]
  def change
    change_column :courses, :catalogNumber, :string
  end
end
