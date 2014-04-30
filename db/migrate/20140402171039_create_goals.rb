class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.string :type
      t.string :customer_id
      t.boolean :commitment_contract
      t.integer :target
      t.integer :money_earned
      t.integer :consecutive
      
      t.timestamps
    end
  end
end
