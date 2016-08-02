require 'rails_helper'

RSpec.describe "feeds/show.html.erb", type: :view do

  it "has a header: Feed" do
   assign(:posts, Post.none)
   render

   expect(rendered).to have_selector("h1", text: "Feed")
  end

  it "has a form for creating a new post" do
   assign(:posts, Post.none)
   render

   pending "Not yet implemented"
   expect(rendered).to have_selector("form", text: "Write new post")
  end

  context "when there are posts to show" do
    let(:posts) { build_stubbed_list(:post, 10) }

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
