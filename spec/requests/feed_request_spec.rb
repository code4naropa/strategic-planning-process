require 'rails_helper'
include SignInHelper

RSpec.describe "Feed", type: :request do
  describe "GET #show" do

    let(:user) { create(:user) }
    before { sign_in_as( user ) }

    describe "variables" do

      describe "@posts" do
        let!(:posts_of_anyone_in_the_community) { create_list(:post, 20).reverse }
        let(:posts) { @controller.instance_variable_get(:@posts) }

        it "assigns posts of anyone in the community" do
          get feed_path
          expect(posts).to match(posts_of_anyone_in_the_community)
        end
      end

    end

  end
end
