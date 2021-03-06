module BaseApi

  shared_examples_for "invalid delete user interaction" do
    it "the outcome is supposed to be invalid" do
      expect(subject.valid?).to be_falsey
    end
  end

  describe Users::DeleteUser do
    let!(:user)               { create :admin_user }
    let(:valid_params)        { Hash["id" => user.id] }
    let(:wrong_format_params) { Hash["id" => "foo"] }
    let(:not_found_params)    { Hash["id" => 12] }
    let(:interaction)         { described_class }


    describe "#run with correct params" do
      subject { interaction.run(valid_params) }

      it { is_expected.to be_truthy }

      it "the outcome is supposed to be valid" do
        expect(subject.valid?).to be_truthy
      end

      it "returns the deleted user" do
        expect(subject.result).to eq user
      end

      it "deletes the user" do
        expect { subject }.to change { BaseAuth::User.count }.by(-1)
      end
    end

    describe "#run with malformed params" do
      it_behaves_like "invalid delete user interaction"

      subject { interaction.run(wrong_format_params) }

      it "sets errors on the interaction" do
        expect(subject.errors.first[0]).to be :id
      end
    end

    describe "#run with wrong params" do
      it_behaves_like "invalid delete user interaction"

      subject { interaction.run(not_found_params) }

      it "sets errors on the interaction" do
        expect(subject.errors.first[0]).to be :id
        expect(subject.errors.first[1]).to eq "does not exist"
      end
    end
  end
end
