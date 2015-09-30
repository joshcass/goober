class AddCostToTrip < ActiveRecord::Migration
  def change
    add_column :trips, :cost, :decimal
  end
end
