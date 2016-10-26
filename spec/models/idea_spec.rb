require 'rails_helper'
require 'models/shared_examples/examples_for_likable.rb'

RSpec.describe Idea, type: :model do

  subject(:idea) { build_stubbed(:idea) }

  it "has a valid factory" do
    is_expected.to be_valid
  end

  it_behaves_like "a likable object" do
    subject(:likable) { idea }
  end

  describe "associations" do
    it { is_expected.to belong_to(:author).dependent(false).class_name('User') }
  end

  describe "scopes" do

    describe ":most_recent_first" do
      after { Idea.most_recent_first }

      it "orders idea by their creation date in descending order" do
        expect(Idea).to receive(:order).with('ideas.created_at DESC')
      end

    end

    describe ":with_associations" do
      before { create(:idea) }
      let(:idea) { Idea.with_associations.first }

      it "eagerloads author" do
        expect(idea.association(:author)).to be_loaded
      end

      it "eagerloads likes" do
        expect(idea.association(:likes)).to be_loaded
      end

    end

  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_length_of(:content).is_at_most(250) }
  end

  describe "#readable_by?" do
    let(:user) { build_stubbed(:user) }

    context "when calling the function" do
      it "returns true in any case" do
        expect(idea.send(:readable_by?, nil)).to be true
      end
    end
  end

  describe "#deletable_by?" do

    context "when user is nil" do
      let(:user) { nil }

      it "returns false" do
        is_expected.not_to be_deletable_by(user)
      end
    end

    context "when user is not author of idea" do
      let(:user) { object_double(idea.author, :id => idea.author.id + 1) }

      it "returns false" do
        is_expected.not_to be_deletable_by(user)
      end
    end

    context "when user is author of idea" do
      let(:user) { idea.author }

      it "returns true" do
        is_expected.to be_deletable_by(user)
      end
    end

  end
end
