class CreateFares < ActiveRecord::Migration
  def change
    create_table :fares do |t|
      t.references :driver, index: true
      t.references :trip, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
