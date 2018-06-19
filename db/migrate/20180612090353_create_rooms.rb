class CreateRooms < ActiveRecord::Migration[5.2]
  def self.up
    create_table :rooms do |t|
      t.string :name,          null: false
      t.timestamp :expires_at, null: false
      t.integer :minimal_bid,  null: false
      t.integer :winner_bid,   default: 0
      t.integer :winner_bid_id
      t.string :winner_user_email
      t.timestamps
    end
    add_index :rooms, :expires_at
  end

  def self.down
    drop_table :rooms
  end
end
