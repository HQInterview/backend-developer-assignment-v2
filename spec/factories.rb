FactoryBot.define do

  factory :user do
    sequence(:email) {|n| "user#{n}@auctions.com" }
    password "password"
    activation_state "active"
  end

  factory :room do
    sequence(:name) {|n| "Room ##{n} in Hotel #{Faker::Company.name}" }
    expires_at 10.minutes.from_now
    minimal_bid { rand(10..50) * 100 }
  end

  factory :bid do
    accepted true
    amount { rand(10..50) * 100 }
    association :user, factory: :user
    association :room, factory: :room

    after(:build) do |bid|
      bid.update_attribute :user_email, bid.user.email
    end
  end

end
