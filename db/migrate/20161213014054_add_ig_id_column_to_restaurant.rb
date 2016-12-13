class AddIgIdColumnToRestaurant < ActiveRecord::Migration[5.0]
  def change
    add_column :restaurants, :ig_id, :string
  end
end
