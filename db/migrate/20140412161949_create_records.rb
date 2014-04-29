class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.integer :score
      t.integer :user_id
      t.integer :phase_id
      t.integer :easiness
      t.integer :sub_goal
      t.string :color
      t.date :date

      t.timestamps
    end
  end
end
