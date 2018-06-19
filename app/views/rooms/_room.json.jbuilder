json.extract! room, :id, :name, :expires_at, :minimal_bid, :winner_bid, :winner_bid_id, :winner_user_email, :created_at, :updated_at
json.url room_url(room, format: :json)
json.bids room.bids, partial: "bids/bid", as: :bid
