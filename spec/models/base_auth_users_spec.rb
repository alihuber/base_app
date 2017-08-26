require "rails_helper"


describe BaseAuth::User do
  let(:user)       { create :user }
  let(:admin_user) { create :admin_user }

  it "has a valid factory" do
    expect(user).to be_valid
  end

  it "has admin flags" do
    expect(user.admin?).to be false
    expect(admin_user.admin?).to be true
  end
end
