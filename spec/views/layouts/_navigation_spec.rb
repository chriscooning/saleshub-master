require "spec_helper"
require "common/users"
require 'draper/test/rspec_integration'

describe "layouts/_navigation.html.slim" do
  before(:each) do
    @emil ||= emil_user
    sign_in @emil if !view.user_signed_in?
  end

  it "shows 'Manage Messages' link for authorized users" do
    access_table = @emil.access_table
    access_table[:permissions] = { messages: [:read, :create] }
    access_table.save

    render partial: 'layouts/navigation'
    expect(rendered).to include("Manage Messages")

    access_table = @emil.access_table
    access_table[:permissions] = { messages: [:read, :edit] }
    access_table.save

    render partial: 'layouts/navigation'
    expect(rendered).to include("Manage Messages")

    access_table = @emil.access_table
    access_table[:permissions] = { messages: [:read, :delete] }
    access_table.save

    render partial: 'layouts/navigation'
    expect(rendered).to include("Manage Messages")
  end

  it "does not show 'Manage Messages' link for not authorized users" do
    access_table = @emil.access_table
    access_table[:permissions] = { messages: [:read] }
    access_table.save

    render partial: 'layouts/navigation'
    expect(rendered).not_to include("Manage Messages")

    # Only 'create/edit/delete' is insufficient to access manage page
    access_table = @emil.access_table
    access_table[:permissions] = { messages: [:create, :edit, :delete] }
    access_table.save

    render partial: 'layouts/navigation'
    expect(rendered).not_to include("Manage Messages")
  end
end