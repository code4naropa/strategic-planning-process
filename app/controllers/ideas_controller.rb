class IdeasController < ApplicationController
  before_action :authorize, only: [:create, :destroy]
  before_action :current_user, only: [:index, :show]
  before_action :set_idea_with_assocations, only: [:show]
  before_action :set_idea_without_associations, only: [:destroy]

  # GET /ideas
  def index
    @ideas = Idea.with_associations.most_recent_first.all

    # create new idea
    @idea = Idea.new
  end

  # GET /idea/1
  def show
    render_404 and return unless @idea
    render_404 and return unless @idea.readable_by?(@current_user)
  end


  # POST /idea
  def create
    @idea = Idea.new(idea_params)
    @idea.author = @current_user

    if @idea.save
      redirect_to ideas_path, notice: 'Idea was successfully created.'
    else
      @ideas = Idea.with_associations.most_recent_first.all
      render :index
    end
  end

  # DELETE /idea/1
  def destroy
    @idea.destroy
    redirect_to ideas_path, notice: 'Idea was successfully deleted.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_idea_without_associations
      @idea = Idea.find_by id: params[:id]
    end

    def set_idea_with_assocations
      @idea = Idea.with_associations.find_by id: params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def idea_params
      params.require(:idea).permit(:content)
    end
end
