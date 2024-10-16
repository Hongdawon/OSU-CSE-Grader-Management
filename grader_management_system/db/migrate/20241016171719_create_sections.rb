class CreateSections < ActiveRecord::Migration[7.2]
  def change
    create_table :sections do |t|
      t.integer :courseId
      t.string :sectionNumber
      t.string :instructionMode
      t.string :location
      t.string :startTime
      t.string :endTime
      t.string :startDate
      t.string :endDate
      t.string :meetingDays
      t.string :instructorName

      t.timestamps
    end
  end
end
