class AddAmountOfBidsToUsers < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :amount_of_bids, :integer, default: 0
    User.reset_column_information
    User.all.each do |item|
      item.update_attribute :amount_of_bids, item.bids.size
    end
  end

  def down
    remove_column :users, :amount_of_bids
  end
end
