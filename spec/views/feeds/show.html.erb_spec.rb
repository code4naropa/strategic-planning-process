require 'rails_helper'

RSpec.describe "feeds/show.html.erb", type: :view do

  before do
    assign(:post, Post.new)
    assign(:current_user, build_stubbed(:user))
  end

  it "has a header: Conversations" do
   assign(:posts, Post.none)
   render

   expect(rendered).to have_selector("h1", text: "Conversations")
  end

  context "when user is signed in and confirmed" do
    it "has a form for creating a new post" do
     assign(:posts, Post.none)
     assign(:current_user, build_stubbed(:user))
     render

     expect(rendered).to have_selector("form", text: "Post")
    end
  end

  context "when user is signed in but not confirmed" do
    it "shows a message to confirm email address" do
     assign(:posts, Post.none)
     assign(:current_user, build_stubbed(:user, :confirmed_registration => false))
     render

     expect(rendered).to have_selector("div.notice", text: "Please confirm your email address to create a new post")
    end
  end

  context "when user is not signed in" do
    it "shows a message to confirm email address" do
     assign(:posts, Post.none)
     assign(:current_user, nil)
     render

     expect(rendered).to have_selector("div.notice", text: "Please log in or sign up to create a new post")
    end
  end

  context "when there are posts to show" do
    let(:posts) { create_list(:post, 10) }

    it "shows posts" do
     assign(:posts, posts)
     render

     posts.each do |post|
       expect(rendered).to have_text(post.content)
       expect(rendered).to have_text(post.author.name)
     end

    end

  end

  context "when there are no posts to show" do
    let(:posts) { Post.none }

    it "shows message" do
     assign(:posts, posts)
     render

     expect(rendered).to have_text("There are no posts to show. Why don't you " +
        "write one to get started?")
    end

  end

end
