require "spec_helper"
require "common/users"

describe "news_entries/index.html.slim" do
  before(:each) do
    @emil ||= emil_user
    sign_in @emil if !view.user_signed_in?
    assign(:internal_news_entries, [])
    assign(:external_news_entries, [])
  end

  it "shows news entry creation button for authorized user" do
    access_table = @emil.access_table
    access_table[:permissions] = { news: [:create] }
    access_table.save

    render
    expect(rendered).to have_css("a", text: 'Create News Entry')
  end

  it "does not show new entry creation button for not authorized user" do
    access_table = @emil.access_table
    access_table[:permissions] = {}
    access_table.save

    render
    expect(rendered).not_to have_css("a", text: 'Create News Entry')
  end
end