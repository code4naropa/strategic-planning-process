require 'rails_helper'
include SignInHelper

RSpec.describe "profiles/show", type: :view do
  before(:each) do
    @profile = create(:user).profile
    @current_user = create(:user)
    @posts = []
  end

  it "renders user's name" do
    render
    expect(rendered).to have_text(@profile.user.name)
  end

  it "renders most recent posts first" do
    @posts_to_check = []
    5.times { @posts_to_check << create(:post, :author => @current_user) }

    @posts = @current_user.posts.most_recent_first.with_associations

    render

    expect(@posts_to_check[4].content).to appear_before(@posts_to_check[3].content)
    expect(@posts_to_check[3].content).to appear_before(@posts_to_check[2].content)
    expect(@posts_to_check[2].content).to appear_before(@posts_to_check[1].content)
    expect(@posts_to_check[1].content).to appear_before(@posts_to_check[0].content)
  end

end
