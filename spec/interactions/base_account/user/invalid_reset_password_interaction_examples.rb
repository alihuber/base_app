require "rails_helper"

shared_examples_for "invalid reset password interaction" do
  it "the outcome is supposed to be invalid" do
    expect(subject.valid?).to be_falsey
  end

  it "does not update the user record" do
    expect {
      subject
    }.not_to change { user.reload.updated_at }
  end

  it "does not remove the reset token from the user" do
    expect {
      subject
    }.not_to change { user.reload.password_reset_token }
  end

  it "does not remove the request password reset timestamp" do
    expect {
      subject
    }.not_to change { user.reload.password_reset_sent_at }
  end

  it "does not reset the password of the user" do
    expect {
      subject
    }.not_to change { user.reload.password_digest }
  end
end

shared_examples_for "reset password interaction with token error" do
  it "sets errors on the interaction" do
    expect(subject.errors[:token]).to be_present
  end
end

shared_examples_for "reset password interaction with password blank error" do
  it "sets validation errors on the interaction" do
    expect(subject.errors.details[:password].first[:error])
      .to eq :blank
  end
end

shared_examples_for "reset password interaction with password length error" do
  it "sets validation errors on the interaction" do
    expect(subject.errors.details[:password].first[:error])
      .to eq :too_short
  end
end
