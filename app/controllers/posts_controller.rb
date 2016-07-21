class PostsController < ApplicationController
  before_action :authorize, except: [:show]
  before_action :current_user, only: [:show]
  before_action :set_post, only: [:show, :destroy]

  # GET /posts/1
  def show
    render_404 and return unless @post
    render_404 and return unless @post.can_be_seen_by?(@current_user)
  end

  # GET /new-post
  def new
    @post = Post.new
  end


  # POST /posts
  def create
    @post = Post.new(post_params)
    @post.author = @current_user

    if @post.save
      redirect_back fallback_location: @post, notice: 'Post was successfully created.'
    else
      render :new
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy
    redirect_to profile_path(@current_user), notice: 'Post was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find_by id: params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:content)
    end
end
