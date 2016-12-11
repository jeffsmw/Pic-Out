class CreateResults < ActiveRecord::Migration[5.0]
  def change
    create_table :results do |t|
      t.string :image
      t.string :ig_slug
      t.references :search, foreign_key: true

      t.timestamps
    end
  end
end
