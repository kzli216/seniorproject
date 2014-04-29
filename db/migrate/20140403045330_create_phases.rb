class CreatePhases < ActiveRecord::Migration
  def change
    create_table :phases do |t|
      t.integer :subgoal
      t.boolean :baseline
      t.integer :goal_id

      t.timestamps
    end
  end
end
