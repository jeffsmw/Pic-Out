class CreateRestaurants < ActiveRecord::Migration[5.0]
  def change
    create_table :restaurants do |t|
      t.string :zm_id
      t.string :name
      t.string :url
      t.string :cuisine
      t.string :price
      t.string :latitude
      t.string :longitude

      t.timestamps
    end
  end
end
