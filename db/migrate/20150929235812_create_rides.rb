class CreateRides < ActiveRecord::Migration
  def change
    create_table :rides do |t|
      t.references :rider, index: true
      t.references :trip, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
