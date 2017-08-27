require "rails_helper"

module BaseAccount

  shared_examples_for "invalid update user interaction" do
    it "the outcome is supposed to be invalid" do
      expect(subject.valid?).to be_falsey
    end
  end

  describe User::UpdateUser, type: :model do
    let!(:user)               { create :user }
    let(:all_valid_inputs)    { Hash["email" => "foo@bar.com",
                                   "password" => "123456",
                                   "password_confirmation" => "123456"] }
    let(:all_valid_param)     { {user: user}.reverse_merge(all_valid_inputs) }
    let(:not_changed_input)   { Hash["email" => "", "password" => "",
                                   "password_confirmation" => ""] }
    let(:not_changed_param)   { {user: user}.reverse_merge(not_changed_input) }
    let(:email_only_input)    { Hash["email" => "foo@bar.com", "password" => "",
                                   "password_confirmation" => ""] }
    let(:email_only_param)    { {user: user}.reverse_merge(email_only_input) }
    let(:pwd_only_input)      { Hash["email" => "", "password" => "123456",
                                   "password_confirmation" => "123456"] }
    let(:pwd_only_param)      { {user: user}.reverse_merge(pwd_only_input) }
    let(:too_short_input)     { Hash["email" => "", "password" => "123",
                                   "password_confirmation" => "123"] }
    let(:too_short_param)     { {user: user}.reverse_merge(too_short_input) }
    let(:not_equal_input)     { Hash["email" => "", "password" => "123456",
                                   "password_confirmation" => "654321"] }
    let(:not_equal_param)     { {user: user}.reverse_merge(not_equal_input) }
    let(:mixed_invalid_input) { Hash["email" => "foo@bar.com",
                                     "password" => "123456",
                                     "password_confirmation" => "654321"] }
    let(:mixed_invalid_param) { {user: user}.reverse_merge(mixed_invalid_input) }
    let(:interaction)         { described_class }


    describe "#run with all replaced correct params" do
      subject { interaction.run(all_valid_param) }

      it { is_expected.to be_truthy }

      it "the outcome is supposed to be valid" do
        expect(subject.valid?).to be_truthy
      end

      it "updates the user" do
        expect { subject }
          .to change { user.reload.email }
          .and change { user.reload.password_digest }
      end

      it "returns the user" do
        expect(subject.result).to be_a BaseAuth::User
      end
    end

    describe "#run with no changed params" do
      subject { interaction.run(not_changed_param) }

      it { is_expected.to be_truthy }

      it "the outcome is supposed to be valid" do
        expect(subject.valid?).to be_truthy
      end

      it "does not update the user" do
        expect { subject }
          .not_to change { user.reload.email }
        expect { subject }
          .not_to change { user.reload.password_digest }
      end

      it "returns the user" do
        expect(subject.result).to be_a BaseAuth::User
      end
    end

    describe "#run with changed email only" do
      subject { interaction.run(email_only_param) }

      it { is_expected.to be_truthy }

      it "the outcome is supposed to be valid" do
        expect(subject.valid?).to be_truthy
      end

      it "does partially update the user" do
        expect { subject }
          .to change { user.reload.email }
        expect { subject }
          .not_to change { user.reload.password_digest }
      end

      it "returns the user" do
        expect(subject.result).to be_a BaseAuth::User
      end
    end

    describe "#run with changed password only" do
      subject { interaction.run(pwd_only_param) }

      it { is_expected.to be_truthy }

      it "the outcome is supposed to be valid" do
        expect(subject.valid?).to be_truthy
      end

      it "does partially update the user" do
        expect { subject }
          .to change { user.reload.password_digest }
        expect { subject }
          .not_to change { user.reload.email }
      end

      it "returns the user" do
        expect(subject.result).to be_a BaseAuth::User
      end
    end

    describe "#run with too short passwords" do
      it_behaves_like "invalid update user interaction"

      subject { interaction.run(too_short_param) }

      it "sets errors on the interaction" do
        expect(subject.errors.first[0]).to be :password
        expect(subject.errors.first[1]).to include "6"
      end
    end

    describe "#run with not equal passwords" do
      it_behaves_like "invalid update user interaction"

      subject { interaction.run(not_equal_param) }

      it "sets errors on the interaction" do
        expect(subject.errors.first[0]).to be :password
        expect(subject.errors.first[1]).to eq "passwords do not match"
      end
    end

    describe "#run with mixed invalid input" do
      it_behaves_like "invalid update user interaction"

      subject { interaction.run(mixed_invalid_param) }

      it "sets errors on the interaction" do
        expect(subject.errors.first[0]).to be :password
        expect(subject.errors.first[1]).to eq "passwords do not match"
      end

      it "does not update the user" do
        expect { subject }.not_to change { user.reload }
      end
    end
  end
end
