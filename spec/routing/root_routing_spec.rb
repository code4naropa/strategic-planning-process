require "rails_helper"

RSpec.describe "routes for root", :type => :routing do

  it "routes to democracy/communities#show" do

    expect(:get => "/").to route_to(
      :controller => "democracy/communities",
      :action => "show"
    )

  end

end
