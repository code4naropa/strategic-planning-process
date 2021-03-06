require 'rails_helper'
require 'models/shared_examples/examples_for_likable.rb'

RSpec.describe Comment, type: :model do

  subject(:comment) { build(:comment) }

  it "has a valid factory" do
    is_expected.to be_valid
  end

  it_behaves_like "a likable object" do
    subject(:likable) { comment }
  end

  describe "associations" do
    it { is_expected.to belong_to(:author).dependent(false).class_name('User') }
    it { is_expected.to belong_to(:commentable).dependent(false) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:author) }
    it { is_expected.to validate_presence_of(:commentable_type) }
    it { is_expected.to validate_presence_of(:commentable_id) }
    # gives error: wrong constant name shoulda-matchers test string
    # it { is_expected.to validate_inclusion_of(:commentable_type).
    #      in_array(['Post', 'Democracy::Community::Decision']) }

    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_length_of(:content).is_at_most(1000) }

    it "validates that #author_must_be_able_to_see_post" do
      expect(comment).to receive(:author_must_be_able_to_see_commentable)
      comment.valid?
    end
  end

  describe "#deletable_by?" do

    context "when user is nil" do
      let(:user) { nil }

      it "returns false" do
        is_expected.not_to be_deletable_by(user)
      end
    end

    context "when user is not author of comment" do
      let(:user) { object_double(comment.author, :id => comment.author.id + 1) }

      it "returns false" do
        is_expected.not_to be_deletable_by(user)
      end
    end

    context "when user is author of comment" do
      let(:user) { comment.author }

      it "returns true" do
        is_expected.to be_deletable_by(user)
      end
    end

  end

  describe "#author_must_be_able_to_see_commentable" do
    let(:post) { comment.commentable }
    after { comment.send(:author_must_be_able_to_see_commentable) }

    it "checks whether the post is readable by the comment author" do
      expect(post).to receive(:readable_by?).with(comment.author)
    end

    context "when author cannot see post" do
      before { allow(post).to receive(:readable_by?) { false } }

      it "adds an error message" do
        expect(comment.errors[:base]).to receive(:<<).
          with("An error occurred. " +
          "Either the post never existed, it does not exist anymore, " +
          "or you do not have permission to view it.")
      end

    end

    context "when author can see post" do
      before { allow(post).to receive(:readable_by?) { true } }

      it "does not add an error message" do
        expect(comment.errors[:base]).not_to receive(:<<).
          with("An error occurred. " +
          "Either the post never existed, it does not exist anymore, " +
          "or you do not have permission to view it.")
      end

    end

  end

end
