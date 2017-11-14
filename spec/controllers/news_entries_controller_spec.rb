require "spec_helper"
require "common/users"

describe NewsEntriesController do
  before(:each) do
    request.env["devise.mapping"] = Devise.mappings[:user]
    @emil ||= emil_user
    sign_in @emil if !controller.user_signed_in?
    2.times do |i|
      NewsEntry.create!(
        news_type: NewsEntry::Types::EXTERNAL,
        title: 'Now doing',
        body: 'Biathlon 2014',
        link: "http://example.com/biathlon-#{i}",
        link_hashcode: i
      )
      NewsEntry.create!(
        news_type: NewsEntry::Types::INTERNAL,
        body: 'Bjornsdallen won',
        title: 'Biathlon results'
      )
    end
  end

  describe "GET #index" do
    it "shows news entries list to authorized user" do
      access_table = @emil.access_table
      access_table[:permissions] = { news: [:read] }
      access_table.save
      get :index
      expect(response.status).to eq 200
      expect(assigns(:internal_news_entries).size).to eq 2
      expect(assigns(:external_news_entries).size).to eq 2
    end

    it "does not show news entries list to not authorized user" do
      access_table = @emil.access_table
      access_table[:permissions] = {}
      access_table.save
      get :index
      expect(response.status).to eq 302
      expect(response).to redirect_to(root_path)
      expect(flash[:error]).to eq 'Access denied'
    end
  end

  describe "POST #create" do
    before(:each) do
      NewsEntry.delete_all
    end
    it "creates a news entry for authorized user" do
      Timecop.freeze
      access_table = @emil.access_table
      access_table[:permissions] = { news: [:create] }
      access_table.save

      attributes = {
        title: "New promotion",
        body:  "John Doe has been promoted from Salinas Plant Manager to Regional Plant Manager"
      }
      post :create, news_entry: attributes
      expect(response.status).to eq 302
      expect(response).to redirect_to(news_entries_path)
      news_entries = NewsEntry.all
      expect(news_entries.size).to eq 1
      entry = news_entries.first
      expect(entry.title).to eq "New promotion"
      expect(entry.body).to eq "John Doe has been promoted from Salinas Plant Manager to Regional Plant Manager"
      expect(entry.news_type).to eq NewsEntry::Types::INTERNAL
      expect(entry.pub_date).to eq Time.now
    end

    it "handles validation failures" do
      access_table = @emil.access_table
      access_table[:permissions] = { news: [:create] }
      access_table.save

      post :create, news_entry: {title: '', body: ''}
      expect(response.status).to eq 200
      expect(response).to render_template('news_entries/new')
      expect(NewsEntry.count).to eq 0
      expect(assigns(:news_entry)).not_to be_valid
    end
  end
end