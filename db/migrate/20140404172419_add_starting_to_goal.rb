class AddStartingToGoal < ActiveRecord::Migration
  def change
    add_column :goals, :starting, :boolean
  end
end
