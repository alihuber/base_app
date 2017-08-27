module BaseApi

  shared_examples_for "invalid create user interaction" do
    it "the outcome is supposed to be invalid" do
      expect(subject.valid?).to be_falsey
    end
  end

  describe Users::CreateUser do
    let(:valid_params)   { Hash[email: "email@foo.com", password: "123456"] }
    let(:short_params)   { Hash[email: "email@foo.com", password: "123"] }
    let(:blank_params_1) { Hash[email: "email@foo.com", password: ""] }
    let(:blank_params_2) { Hash[email: "", password: "123456"] }
    let(:interaction)    { described_class }


    describe "#run with correct params" do
      subject { interaction.run(valid_params) }

      it { is_expected.to be_truthy }

      it "the outcome is supposed to be valid" do
        expect(subject.valid?).to be_truthy
      end

      it "returns the created user" do
        expect(subject.result).to be_a BaseAuth::User
        expect(subject.result.email).to eq "email@foo.com"
      end

      it "creates the user" do
        expect { subject }.to change { BaseAuth::User.count }.by(1)
      end
    end

    describe "#run with invalid params" do
      it_behaves_like "invalid create user interaction"

      subject { interaction.run(short_params) }

      it "sets errors on the interaction" do
        expect(subject.errors.first[0]).to be :password
        expect(subject.errors.first[1]).to include "6"
      end
    end

    describe "#run with no password param" do
      it_behaves_like "invalid create user interaction"

      subject { interaction.run(blank_params_1) }

      it "sets errors on the interaction" do
        expect(subject.errors.first[0]).to be :password
        expect(subject.errors.first[1]).to include "6"
      end
    end

    describe "#run with no email param" do
      it_behaves_like "invalid create user interaction"

      subject { interaction.run(blank_params_2) }

      it "sets errors on the interaction" do
        expect(subject.errors.first[0]).to be :email
      end
    end
  end
end
