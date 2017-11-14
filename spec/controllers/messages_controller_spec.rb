require "spec_helper"
require "common/users"

describe MessagesController do
  before(:each) do
    request.env["devise.mapping"] = Devise.mappings[:user]
    @emil ||= emil_user
    sign_in @emil if !controller.user_signed_in?
    Message.create!(
      author_name: 'Edgar Poe',
      message_type: 0, # FIXME: use more sensible type when types will be defined
      body: 'Watching biatlon',
      title: 'Now doing'
    )
    Message.create!(
      author_name: 'Edgar Poe',
      message_type: 0, # FIXME: use more sensible type when types will be defined
      body: 'Bjornsdallen won',
      title: 'Biathlon results'
    )
  end

  describe "GET #index" do
    it "shows message list to authorized user" do
      access_table = @emil.access_table
      access_table[:permissions] = { messages: [:read] }
      access_table.save
      get :index
      expect(response.status).to eq 200
      messages = assigns(:messages)
      expect(messages.size).to eq 2
    end

    it "does not show message list to not authorized user" do
      access_table = @emil.access_table
      access_table[:permissions] = {}
      access_table.save
      get :index
      expect(response.status).to eq 302
      expect(response).to redirect_to(root_path)
      expect(flash[:error]).to eq 'Access denied'
    end
  end

  describe "GET #manage" do
    it "shows message list for management tot authorized user" do
      access_table = @emil.access_table
      access_table[:permissions] = { messages: [:read, :create] }
      access_table.save

      get :manage
      expect(response.status).to eq 200
      expect(response).to render_template("messages/manage")

      access_table = @emil.access_table
      access_table[:permissions] = { messages: [:read, :edit] }
      access_table.save

      get :manage
      expect(response.status).to eq 200
      expect(response).to render_template("messages/manage")

      access_table = @emil.access_table
      access_table[:permissions] = { messages: [:read, :delete] }
      access_table.save

      get :manage
      expect(response.status).to eq 200
      expect(response).to render_template("messages/manage")
    end

    it "does not show message list for management to not authorized user" do
      access_table = @emil.access_table
      access_table[:permissions] = {}
      access_table.save
      get :manage
      expect(response.status).to eq 302
      expect(response).to redirect_to(root_path)
      expect(flash[:error]).to eq 'Access denied'
    end
  end

end