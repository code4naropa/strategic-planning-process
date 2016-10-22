require "rails_helper"

RSpec.describe "routes for sessions", :type => :routing do

  it "routes to sessions#new" do
    expect(:get => "/login").to route_to(
      :controller => "sessions",
      :action => "new"
    )
  end

  it "routes to sessions#create" do
    expect(:post => "/login").to route_to(
      :controller => "sessions",
      :action => "create"
    )
  end

  it "routes to sessions#destroy" do
    expect(:get => "/logout").to route_to(
      :controller => "sessions",
      :action => "destroy"
    )
  end
end
