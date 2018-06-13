FactoryBot.define do

  factory :user do
    sequence(:email) {|n| "user#{n}@miniurl.com" }
    password "password"
    activation_state "active"
  end

  factory :room do
    sequence(:name) {|n| "Room ##{n}in Hotel #{Faker::Company.name}" }
    expires_at 10.minutes.from_now
    minimal_bid { rand(10..50) * 100 }
  end

end
