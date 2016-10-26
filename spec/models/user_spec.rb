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

  describe "#to_param" do
    it "returns the username" do
      expect(user.to_param).to eq(user.username)
    end
  end

  describe ".to_user" do

    context "when input is a string" do
      let(:user) { create(:user) }

      it "returns the user" do
        expect(User.to_user(user.username)).to eq(user)
      end
    end

    context "when input is a User" do
      let(:user) { create(:user) }

      it "returns the user" do
        expect(User.to_user(user)).to eq(user)
      end
    end

    context "when input is a number" do
      it "raises an error" do
        expect{ User.to_user(1) }.to raise_error(ArgumentError)
      end
    end

    context "when input is nil" do
      it "returns nil" do
        expect(User.to_user(nil)).to be_nil
      end
    end

  end

  describe "#send_registration_email" do
    before { allow(Mailjet::Send).to receive(:create) }
    after { user.send_registration_email }

    it "calls registration confirmation path" do
      expect(user).to receive(:registration_confirmation_path)
    end

    it "sends an email" do
      registration_confirmation_path = instance_double(String)
      allow(user).
        to receive(:registration_confirmation_path).
        and_return( registration_confirmation_path )
      expect(Mailjet::Send).to receive(:create).with(
        "FromEmail": "hello@upshift.network",
        "FromName": "Upshift Network",
        "Subject": "Please Confirm Your Registration",
        "Mj-TemplateID": ENV['USER_REGISTRATION_EMAIL_TEMPLATE_ID'],
        "Mj-TemplateLanguage": "true",
        "Mj-trackclick": "1",
        recipients: [{
          'Email' => user.email,
          'Name' => user.name}],
        vars: {
          "NAME" => user.name,
          "CONFIRMATION_PATH" => registration_confirmation_path
        }
      )
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
