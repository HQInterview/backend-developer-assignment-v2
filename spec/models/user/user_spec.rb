require "rails_helper"

RSpec.describe User, type: :model do

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should validate_confirmation_of(:password).with_message("should match confirmation") }

  it { should allow_value("user1@domain.com").for(:email) }
  it { should allow_value("user2@subdomain.domain2.es").for(:email) }
  it { should_not allow_value("user.domain.com").for(:email) }
  it { should_not allow_value("user1@domain.a").for(:email) }
  it { should_not allow_value("user1@domain").for(:email) }
  it { should_not allow_value("user1@.com").for(:email) }
  it { should_not allow_value("user1@domain.comcom").for(:email) }

  it "should validate_uniqueness_of :email" do
    user = create :user
    expect(
      lambda{
        new_user = create :user, email: user.email
      }
    ).to raise_error "Validation failed: Email has already been taken"
  end
end
