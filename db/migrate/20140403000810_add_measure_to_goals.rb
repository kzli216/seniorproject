class AddMeasureToGoals < ActiveRecord::Migration
  def change
    add_column :goals, :measure, :string
  end
end
