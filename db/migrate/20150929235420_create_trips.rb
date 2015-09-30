class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.string :pickup_location
      t.string :dropoff_location
      t.integer :passengers
      t.integer :status, default: 0
      t.datetime :accepted_time
      t.datetime :pickup_time
      t.datetime :dropoff_time

      t.timestamps null: false
    end
  end
end
