require "spec_helper"

module BaseAccount
  describe User::EditPasswordReset do

    let(:interaction) { described_class }

    describe "#run!" do
      subject { interaction.run! }

      it "instantiates a new 'PasswordReset' object" do
        expect(subject).to be_a User::EditPasswordReset::PasswordReset
      end

      it "responds to password" do
        expect(subject).to respond_to :password
      end
    end
  end
end
