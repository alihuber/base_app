require "spec_helper"

module BaseAuth

  shared_examples_for "invalid create request password reset interaction" do
    it "the outcome is supposed to be invalid" do
      expect(subject.valid?).to be_falsey
    end

    it "does not update the user record" do
      expect {
        subject
      }.not_to change { user.reload.updated_at }
    end

    it "does not set password_reset_token on the user" do
      expect { subject }.not_to change {
        user.reload.password_reset_token }
    end

    it "does not set the password_reset_sent_at on the user" do
      expect { subject }.not_to change {
        user.reload.password_reset_sent_at }
    end

    it "does not send an e-mail to the user" do
      expect(BaseMailer)
        .not_to receive(:deliver)
      subject
    end
  end

  describe User::CreateRequestPasswordReset, type: :model do
    let!(:user)          { create :admin_user }
    let(:valid_params)   { Hash[email: user.email] }
    let(:wrong_params)   { Hash[email: "foo@wrong.org"] }
    let(:blank_params)   { Hash[email: ""] }
    let(:interaction)    { described_class }

    describe "validations" do
      subject { described_class.new(valid_params) }

      it { is_expected.to validate_presence_of :email }
    end

    describe "#run with correct params" do
      subject { interaction.run(valid_params) }

      it { is_expected.to be_truthy }

      it "the outcome is supposed to be valid" do
        expect(subject.valid?).to be_truthy
      end

      it "updates the user record" do
        expect { subject }.to change { user.reload.updated_at }
      end

      it "sets the password_reset_token on the user" do
        expect { subject }.to change {
          user.reload.password_reset_token }
      end

      it "sets the password_reset_sent_at on the user to today" do
        expect { subject }.to change {
          user.reload.password_reset_sent_at }
        expect(user.password_reset_sent_at.to_date)
          .to eq Time.zone.today
      end

      it "sends an e-mail to the user using the authentication mailer" do
        expect(BaseMailer)
          .to receive(:deliver)
          .with("authentication/request_password_reset",
                user.email,
                kind_of(Hash))
        subject
      end
    end

    describe "#run with invalid params" do
      it_behaves_like "invalid create request password reset interaction"

      subject { interaction.run(wrong_params) }

      it "sets validation errors on the interaction" do
        expect(subject.errors[:email]).to be_present
      end
    end

    describe "#run with blank params" do
      it_behaves_like "invalid create request password reset interaction"

      subject { interaction.run(blank_params) }

      it "sets validation errors on the interaction" do
        expect(subject.errors.details[:email].first[:error])
          .to eq :blank
      end
    end
  end
end
