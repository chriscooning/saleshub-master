require "spec_helper"
require "common/users"
require 'draper/test/rspec_integration'

describe "messages/manage" do
  before(:each) do
    @emil ||= emil_user
    sign_in @emil if !view.user_signed_in?
    message = Message.create!(
      author_name: 'Edgar Poe',
      message_type: 0, # FIXME: use more sensible type when types will be defined
      body: 'Watching biatlon',
      title: 'Now doing'
    )
    messages = Message.all.paginate(page: 1, per_page: 1)
    assign(:messages, MessageDecorator.decorate_collection(messages))
  end

  it "shows 'Delete' link for authorized users" do
    access_table = @emil.access_table
    access_table[:permissions] = { messages: [:read, :delete] }
    access_table.save

    render
    expect(rendered).to include("Delete")
  end


  it "shows 'Edit' link for authorized users" do
    access_table = @emil.access_table
    access_table[:permissions] = { messages: [:read, :edit] }
    access_table.save

    render
    expect(rendered).to include("Edit")
  end

  it "does not show 'Delete' and 'Edit' links for not authorized users" do
    access_table = @emil.access_table
    access_table[:permissions] = { messages: [:read] }
    access_table.save

    render
    expect(rendered).not_to include("Delete")
    expect(rendered).not_to include("Edit")
  end
end