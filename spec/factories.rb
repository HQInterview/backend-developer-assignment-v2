FactoryBot.define do

  factory :user do
    sequence(:email) {|n| "user#{n}@miniurl.com" }
    password "password"
    activation_state "active"
  end

end
