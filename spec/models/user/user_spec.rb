require "rails_helper"

RSpec.describe User, type: :model do

  it "should have a CONSTANT named PASSWORD_LENGTH" do
    expect(User::PASSWORD_LENGTH).to eq 8
    expect(User::PASSWORD_LENGTH.frozen?).to be true
  end

  it "should have a CONSTANT named EMAIL_REGEX" do
    expect(User::EMAIL_REGEX).to eq /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/
    expect(User::EMAIL_REGEX.frozen?).to be true
  end

  it { should have_many(:bids).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should validate_confirmation_of(:password).with_message("should match the password") }

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
