require "rails_helper"

RSpec.describe "routes for feeds", :type => :routing do

  it "routes to feeds#index" do
    expect(:get => "/conversations").to route_to(
      :controller => "feeds",
      :action => "show"
    )
  end
end
