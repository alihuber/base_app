require "rails_helper"


describe "Index page" do

  it "has a heading" do
    visit "/"
    expect(page).to have_content("Hello World")
  end

end
