require "spec_helper"
require "common/users"

describe SurveysController do
  before(:each) do
    request.env["devise.mapping"] = Devise.mappings[:user]
    @emil ||= emil_user
    sign_in @emil if !controller.user_signed_in?
  end

  describe "GET #index" do
    it "shows survey list to authorized user" do
      access_table = @emil.access_table
      access_table[:permissions] = { surveys: [:read] }
      access_table.save
      Survey.create!(
        author_id: @emil.id,
        customer_name: "Martin Furkad",
        phone:   "555 555 5555",
        address: "Bond Street",
        zipcode: "90210",
        city:    "Beverly Hills",
        state:   "CA",
        summary: "Good client",
        last_interaction_rating: 5
      )
      Survey.create!(
        author_id: @emil.id,
        customer_name: "Ole Einar Bjorndalen",
        phone:   "555 555 5551",
        address: "Peace Ave",
        zipcode: "90210",
        city:    "Beverly Hills",
        state:   "CA",
        summary: "Awesome",
        last_interaction_rating: 5
      )
      get :index
      expect(response.status).to eq 200
      surveys = assigns(:surveys)
      expect(surveys.size).to eq 2
    end

    it "does not show survey list to not authorized user" do
      access_table = @emil.access_table
      access_table[:permissions] = {}
      access_table.save
      Survey.create!(
        author_id: @emil.id,
        customer_name: "Martin Furkad",
        phone:   "555 555 5555",
        address: "Bond Street",
        zipcode: "90210",
        city:    "Beverly Hills",
        state:   "CA",
        summary: "Good client",
        last_interaction_rating: 5
      )
      get :index
      expect(response.status).to eq 302
      expect(response).to redirect_to(root_path)
      expect(flash[:error]).to eq 'Access denied'
    end
  end
end