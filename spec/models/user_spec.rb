require 'rails_helper'

RSpec.describe User, type: :model do

  subject(:user) { build(:user) }

  it "has a valid factory" do
    is_expected.to be_valid
  end

  it { is_expected.to have_secure_password }

  describe "associations" do
    it { is_expected.to have_many(:posts).dependent(:destroy).
      with_foreign_key("author_id")}
    it { is_expected.to have_many(:comments).dependent(:destroy).
      with_foreign_key("author_id")}

    it { is_expected.to have_many(:likes).dependent(:destroy).
      with_foreign_key("liker_id")}

  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_confirmation_of(:password) }
    it { is_expected.to validate_length_of(:password).is_at_least(8).is_at_most(50) }

    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

    context "validates format of email" do
      it "must contain an @ symbol" do
        user.email = "somestringwithoutatsymbol"
        is_expected.to be_invalid
      end

      it "must not contain spaces" do
        user.email = "address@witha space.com"
        is_expected.to be_invalid
      end

      it "passes actual email addresses" do
        user.email = "email@example.com"
        is_expected.to be_valid
      end

    end

  end

  describe "#registration_confirmation_path" do

    it "returns the url path for confirming the user registration" do
      expect(user.send(:registration_confirmation_path)).
        to eq (
          Rails.application.routes.url_helpers.
            confirm_registration_path(
              :email => user.email,
              :registration_token => user.registration_token
            )
        )
    end
  end

end
