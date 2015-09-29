class CreateCars < ActiveRecord::Migration
  def change
    create_table :cars do |t|
      t.string :make
      t.string :model
      t.integer :capacity
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
