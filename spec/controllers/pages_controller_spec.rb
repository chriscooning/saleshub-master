require "spec_helper"
require "common/users"

describe PagesController do
  before(:each) do
    request.env["devise.mapping"] = Devise.mappings[:user]
    @emil ||= emil_user
    sign_in @emil if !controller.user_signed_in?
  end

  describe "POST #create_survey" do
    it "allows to create a survey for authorized user" do
      access_table = @emil.access_table
      access_table[:permissions] = { surveys: [:create]}
      access_table.save
      attributes = {
        customer_name: 'Martin Furkad',
        phone: '555 555 5555',
        address: 'Bond Street 123',
        zipcode: '90210',
        city: 'Beverly Hills',
        state: 'CA',
        summary: 'Good guy - loves shooting and skiing',
        last_interaction_rating: "3"
      }
      post :create_survey, survey: attributes
      expect(response.status).to eq 302
      expect(response).to redirect_to(root_path)
      expect(assigns(:survey)).to be_valid
      surveys = Survey.all
      expect(surveys.size).to eq 1

      survey = Survey.first
      expect(survey.author_id).to eq @emil.id
      expect(survey.customer_name).to eq 'Martin Furkad'
      expect(survey.last_interaction_rating).to eq 3
    end

    it "handles validation failure" do
      access_table = @emil.access_table
      access_table[:permissions] = { surveys: [:create]}
      access_table.save
      attributes = {
        state: 'PP' # not existing state
      }
      post :create_survey, survey: attributes
      expect(response.status).to eq 200
      expect(response).to render_template("pages/home")
      survey = assigns(:survey)
      expect(survey).not_to be_valid
      expect(Survey.count).to eq 0
      expect(survey.errors[:state]).to be_present
      expect(survey.errors[:customer_name]).to be_present
      expect(survey.errors[:summary]).to be_present
    end


    it "allows to create a survey for admin" do
      begin
        admin = admin_user
        sign_out :user
        sign_in admin
        attributes = {
          customer_name: 'Martin Furkad',
          phone: '555 555 5555',
          address: 'Bond Street 123',
          zipcode: '90210',
          city: 'Beverly Hills',
          state: 'CA',
          summary: 'Good guy - loves shooting and skiing',
          last_interaction_rating: "5"
        }
        post :create_survey, survey: attributes
        expect(response.status).to eq 302
        expect(response).to redirect_to(root_path)
        expect(assigns(:survey)).to be_valid
        surveys = Survey.all
        expect(surveys.size).to eq 1
      ensure
        sign_out :user
      end
    end

    it "does not allow to create a survey for not authorized user" do
      access_table = @emil.access_table
      access_table[:permissions] = {}
      access_table.save
      attributes = {
        customer_name: 'Martin Furkad',
        phone: '555 555 5555',
        address: 'Bond Street 123',
        zipcode: '90210',
        city: 'Beverly Hills',
        state: 'CA',
        summary: 'Good guy - loves shooting and skiing',
        last_interaction_rating: "5"
      }
      post :create_survey, survey: attributes
      expect(response.status).to eq 302
      expect(response).to redirect_to(root_path)
      expect(flash[:error]).to eq 'Access denied'
    end
  end
end