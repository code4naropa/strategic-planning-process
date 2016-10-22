class FeedsController < ApplicationController
  before_action :current_user

  layout "fluid_with_side_nav"

  # GET /
  def show

    # get 30 most recent posts
    @posts =
      Post.with_associations.most_recent_first.limit(30)

    # create new post
    @post = Post.new

  end
end
