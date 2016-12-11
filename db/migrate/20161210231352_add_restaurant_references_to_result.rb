class AddRestaurantReferencesToResult < ActiveRecord::Migration[5.0]
  def change
    add_reference :results, :restaurant, foreign_key: true
  end
end
