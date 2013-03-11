class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :name
      t.string :password
      t.boolean :private
      t.integer :user_id

      t.timestamps
    end
  end
end
