class FeedsController < ApplicationController
  before_action :current_user

  # GET /
  def show

    # get 30 most recent posts
    @posts =
      Post.with_associations.most_recent_first.limit(30)

    # create new post
    @post = Post.new

  end
end
