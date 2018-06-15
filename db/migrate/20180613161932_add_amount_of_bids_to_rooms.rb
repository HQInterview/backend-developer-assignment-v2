class AddAmountOfBidsToRooms < ActiveRecord::Migration[5.2]
  def change
    add_column :rooms, :amount_of_bids, :integer, default: 0
    Room.reset_column_information
    Room.all.each do |item|
      item.update_attribute :amount_of_bids, item.bids.size
    end
  end
end
