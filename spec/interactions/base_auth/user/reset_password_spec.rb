require "rails_helper"
require_relative "invalid_reset_password_interaction_examples"

module BaseAuth
  describe User::ResetPassword, type: :model do
    let!(:user)            { create :admin_user,
                                    password_reset_token: "token123",
                                    password_reset_sent_at: Time.zone.now }
    let!(:tokenless_user)  { create :admin_user,
                                    password_reset_token: nil,
                                    password_reset_sent_at: nil }
    let!(:outdated_user)   {
      create :admin_user,
             password_reset_token: "token234",
             password_reset_sent_at: Time.zone.now - 3.weeks }
    let(:valid_params)     { Hash[password: "new_password", token: "token123"] }
    let(:blank_params_1)   { Hash[password: nil, token: "token123"] }
    let(:blank_params_2)   { Hash[password: "new_password", token: "\"\""] }
    let(:wrong_params_1)   { Hash[password: "new_password", token: "wrong"] }
    let(:wrong_params_2)   { Hash[password: "short", token: "token123"] }
    let(:outdated_params)  { Hash[password: "new_password", token: "token234"] }
    let(:tokenless_params) { Hash[password: "new_password", token: "token456"] }
    let(:interaction)      { described_class }


    describe "validations" do
      subject { described_class.new(valid_params) }

      it { is_expected.to validate_presence_of :password }
      it { is_expected.to validate_length_of(:password).is_at_least(6) }
    end


    describe "#run with valid params" do
      subject { interaction.run(valid_params) }

      it { is_expected.to be_truthy }

      it "the outcome is supposed to be valid" do
        expect(subject.valid?).to be_truthy
        expect(subject.errors.first).to be_nil
      end

      it "updates the user record" do
        expect {
          subject
        }.to change { user.reload.updated_at }
      end

      it "removes the reset token from the user" do
        expect {
          subject
        }.to change { user.reload.password_reset_token }.to nil
      end

      it "removes the request password reset timestamp" do
        expect {
          subject
        }.to change { user.reload.password_reset_sent_at }.to nil
      end

      it "sets the password of the user" do
        expect {
          subject
        }.to change { user.reload.password_digest }
      end
    end

    describe "#run with blank password" do
      it_behaves_like "invalid reset password interaction"
      it_behaves_like "reset password interaction with password blank error"

      subject { interaction.run(blank_params_1) }
    end

    describe "#run with too short password" do
      it_behaves_like "invalid reset password interaction"
      it_behaves_like "reset password interaction with password length error"

      subject { interaction.run(wrong_params_2) }
    end

    describe "#run with blank token" do
      it_behaves_like "invalid reset password interaction"
      it_behaves_like "reset password interaction with token error"

      subject { interaction.run(blank_params_2) }
    end

    describe "#run with wrong token" do
      it_behaves_like "invalid reset password interaction"
      it_behaves_like "reset password interaction with token error"

      subject { interaction.run(wrong_params_1) }
    end


    describe "#run with outdated token" do
      it_behaves_like "invalid reset password interaction"
      it_behaves_like "reset password interaction with token error"

      subject { interaction.run(outdated_params) }
    end

    describe "#run with no token" do
      it_behaves_like "invalid reset password interaction"
      it_behaves_like "reset password interaction with token error"

      subject { interaction.run(tokenless_params) }
    end
  end
end
