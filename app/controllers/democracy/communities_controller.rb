class Democracy::CommunitiesController < ApplicationController
  before_action :current_user
  before_action :set_community

  layout "fluid_with_side_nav"

  # GET /communities/1
  def show
  end

end
