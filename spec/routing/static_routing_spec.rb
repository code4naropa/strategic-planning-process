require "rails_helper"

RSpec.describe "routes for static", :type => :routing do
  it "routes to about page" do
    expect(:get => "/about").to route_to(
      :controller => "static",
      :action => "about"
    )
  end

  it "routes to timeline page" do
    expect(:get => "/timeline").to route_to(
      :controller => "static",
      :action => "timeline"
    )
  end
end
