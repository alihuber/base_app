require "rails_helper"

module BaseAuth

  shared_examples_for "invalid authentication interaction" do
    it "the outcome is supposed to be invalid" do
      expect(subject.valid?).to be_falsey
    end
  end

  describe Api::AuthenticateApiUser, type: :model do
    let!(:user)          { create :admin_user }
    let(:valid_params)   { Hash[email: user.email, password: user.password] }
    let(:wrong_passwd)   { Hash[email: user.email, password: "wrong"] }
    let(:wrong_email)    { Hash[email: "foo@bar",  password: user.password] }
    let(:blank_params_1) { Hash[email: user.email, password: ""] }
    let(:blank_params_2) { Hash[email: "", password: user.password] }
    let(:interaction)    { described_class }

    describe "validations" do
      subject { described_class.new(valid_params) }

      it { is_expected.to validate_presence_of :email }
      it { is_expected.to validate_presence_of :password }
    end

    describe "#run with correct params" do
      subject { interaction.run(valid_params) }

      it { is_expected.to be_truthy }

      it "the outcome is supposed to be valid" do
        expect(subject.valid?).to be_truthy
      end

      it "returns the encoded token" do
        expect(subject.result).to start_with "ey"
      end
    end

    describe "#run with incorrect password" do
      it_behaves_like "invalid authentication interaction"

      subject { interaction.run(wrong_passwd) }

      it "sets errors on the interaction" do
        expect(subject.errors.first[1]).to eq "authentication failed"
      end
    end

    describe "#run with not findable user" do
      it_behaves_like "invalid authentication interaction"

      subject { interaction.run(wrong_email) }

      it "sets errors on the interaction" do
        expect(subject.errors.first[1]).to eq "authentication failed"
      end
    end

    describe "#run with blank password" do
      it_behaves_like "invalid authentication interaction"

      subject { interaction.run(blank_params_1) }

      it "sets validation errors on the interaction" do
        expect(subject.errors.details[:password].first[:error])
          .to eq :blank
      end
    end

    describe "#run with blank email" do
      it_behaves_like "invalid authentication interaction"

      subject { interaction.run(blank_params_2) }

      it "sets validation errors on the interaction" do
        expect(subject.errors.details[:email].first[:error])
          .to eq :blank
      end
    end
  end
end
