class AddTripEstimateInfoToTrip < ActiveRecord::Migration
  def change
    add_column :trips, :estimated_time, :integer
    add_column :trips, :estimated_distance, :integer
  end
end
