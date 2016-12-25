class CreateInvitations < ActiveRecord::Migration[5.0]
  def change
    create_table :invitations do |t|
      t.references :event
      t.references :user
      t.boolean :answer

      t.timestamps
    end
  end
end
