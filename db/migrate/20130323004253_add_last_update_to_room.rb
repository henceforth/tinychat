class AddLastUpdateToRoom < ActiveRecord::Migration
  def change
    add_column :rooms, :last_post, :timestamp
  end
end
