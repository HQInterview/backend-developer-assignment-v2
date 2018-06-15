class CreateBids < ActiveRecord::Migration[5.2]
  def self.up
    create_table :bids do |t|
      t.integer :amount,         null: false
      t.boolean :accepted,       default: true
      t.string :rejection_cause
      t.string :user_email,      null: false
      t.references :user
      t.references :room
      t.timestamps
    end
    add_index :bids, :created_at
  end

  def self.down
    drop_table :bids
  end
end
