require "rails_helper"

module BaseAuth

  shared_examples_for "invalid authorization interaction" do
    it "the outcome is supposed to be invalid" do
      expect(subject.valid?).to be_falsey
    end
  end

  describe Api::AuthorizeApiRequest, type: :model do
    let!(:user)        { create :admin_user }
    let!(:token)       { JsonWebToken.instance.encode(user_id: user.id) }
    let(:valid_header) { Hash["headers" => {"Authorization" => token}] }
    let(:false_header) { Hash["headers" => {"Foo": "bar"}] }
    let(:wrong_token)  { Hash["headers" => {"Authorization": "some.foo"}] }
    let(:other_token)  { Hash["headers" => {"Authorization": "some bar"}] }
    let(:interaction)  { described_class }
    let(:tokenless_header) { Hash["headers" => {"Authorization": ""}] }

    describe "validations" do
      subject { described_class.new(valid_header) }

      it { is_expected.to validate_presence_of :headers }
    end

    describe "#run with correct params" do
      subject { interaction.run(valid_header) }

      it { is_expected.to be_truthy }

      it "the outcome is supposed to be valid" do
        expect(subject.valid?).to be_truthy
      end

      it "returns the user id encoded in the token" do
        expect(subject.result).to be_a BaseAuth::User
        expect(subject.result.id).to eq user.id
      end
    end

    describe "#run with incorrect headers" do
      it_behaves_like "invalid authorization interaction"

      subject { interaction.run(false_header) }

      it "sets header specific errors on the interaction" do
        expect(subject.errors.first[0]).to be :headers
      end
    end

    describe "#run with headers with wrong token" do
      it_behaves_like "invalid authorization interaction"

      subject { interaction.run(wrong_token) }

      it "sets token specific errors on the interaction" do
        expect(subject.errors.first[0]).to be :token
        expect(subject.errors.first[1]).to eq "Invalid token"
      end
    end

    describe "#run with headers with unparseable token" do
      it_behaves_like "invalid authorization interaction"

      subject { interaction.run(other_token) }

      it "sets token specific errors on the interaction" do
        expect(subject.errors.first[0]).to be :token
        expect(subject.errors.first[1]).to eq "Invalid token"
      end
    end

    describe "#run with headers with no token" do
      it_behaves_like "invalid authorization interaction"

      subject { interaction.run(tokenless_header) }

      it "sets token specific errors on the interaction" do
        expect(subject.errors.first[0]).to be :token
        expect(subject.errors.first[1]).to eq "Invalid token"
      end
    end

  end
end
