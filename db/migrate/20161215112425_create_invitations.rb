class CreateInvitations < ActiveRecord::Migration[5.0]
  def change
    create_table :invitations do |t|
      t.string :event_id
      t.string :user_id
      t.boolean :answer

      t.timestamps
    end
  end
end
