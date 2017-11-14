require "spec_helper"
require "common/users"
require 'draper/test/rspec_integration'

describe "pages/home.html.slim" do
  before(:each) do
    @emil ||= emil_user
    sign_in @emil if !view.user_signed_in?
    assign(:survey, Survey.new)
  end

  it "shows survey creation form for authorized user" do
    access_table = @emil.access_table
    access_table[:permissions] = { surveys: [:create]}
    access_table.save

    render
    expect(rendered).to have_css("input[value='Save Survey Entry']")
  end

  it "does not show survey creation form for not authorized user" do
    access_table = @emil.access_table
    access_table[:permissions] = {}
    access_table.save

    assign(:survey, Survey.new)

    render
    expect(rendered).not_to have_css("input[value='Save Survey Entry']")
  end

  it "shows survey index link for authorized user" do
    access_table = @emil.access_table
    access_table[:permissions] = { surveys: [:read]}
    access_table.save

    render
    expect(rendered).to have_css("a", text: 'Show All Past Surveys')
  end

  it "does not show survey index link for not authorized user" do
    access_table = @emil.access_table
    access_table[:permissions] = {}
    access_table.save

    render
    expect(rendered).not_to have_css("a", text: 'Show All Past Surveys')
  end

  it "shows messages and messages index link for authorized user" do
    Message.create!(
      author_name: 'Edgar Allan Poe',
      message_type: 0,
      body: "First msg",
      title: 'first'
    )
    Message.create!(
      author_name: 'John Steinbeck',
      message_type: 0,
      body: "Second msg",
      created_at: Time.now,
      title: 'first'
    )
    messages = MessageDecorator.decorate_collection(Message.all)
    assign(:messages, messages)

    access_table = @emil.access_table
    access_table[:permissions] = { messages: [:read]}
    access_table.save

    render
    # Shows two messages at home page
    expect(rendered).to include("Edgar Allan Poe")
    expect(rendered).to include("John Steinbeck")
    expect(rendered).to have_css('ul.timeline li', count: 2)

    expect(rendered).to have_css("h2", text: 'Messaging')
    expect(rendered).to have_css("ul.timeline")
  end

  it "does not show messages and messages for not authorized user" do
    access_table = @emil.access_table
    access_table[:permissions] = {}
    access_table.save

    render
    expect(rendered).not_to have_css("h2", text: 'Messages')
    expect(rendered).not_to have_css("ul.timeline")
  end

  it "shows news_entries and news_entries index link for authorized user" do
    NewsEntry.create!(
      title: 'First article',
      body: "First article body",
      news_type: NewsEntry::Types::INTERNAL
    )
    NewsEntry.create!(
      title: 'Second article',
      body: "Second article body",
      news_type: NewsEntry::Types::EXTERNAL,
      link: 'http://example.com/second-article',
      link_hashcode: 1
    )

    internal_news_entries = NewsEntryDecorator.decorate_collection(NewsEntry.internal)
    external_news_entries = NewsEntryDecorator.decorate_collection(NewsEntry.external)
    assign(:internal_news_entries, internal_news_entries)
    assign(:external_news_entries, external_news_entries)

    access_table = @emil.access_table
    access_table[:permissions] = { news: [:read]}
    access_table.save

    render

    expect(rendered).to include("First article")
    expect(rendered).to include("Second article")

    expect(rendered).to have_css("h2", text: 'News')
    expect(rendered).to have_css("h3", text: 'External')
    expect(rendered).to have_css("h3", text: 'Internal')
  end

  it "does not show messages and messages for not authorized user" do
    NewsEntry.create!(
      title: 'First article',
      body: "First article body",
      news_type: NewsEntry::Types::INTERNAL
    )
    access_table = @emil.access_table
    access_table[:permissions] = {}
    access_table.save

    render
    expect(rendered).not_to include("First article")

    expect(rendered).not_to have_css("h2", text: 'News')
    expect(rendered).not_to have_css("h3", text: 'External')
    expect(rendered).not_to have_css("h3", text: 'Internal')
  end
end