require "rails_helper"

module BaseAccount
  describe User::RequestPasswordReset do

    let(:interaction) { described_class }

    describe "#run!" do
      subject { interaction.run! }

      it "instantiates a 'PasswordReset' object" do
        expect(subject).to(
          be_a User::RequestPasswordReset::PasswordReset)
      end

      it "responds to email" do
        expect(subject).to respond_to :email
      end
    end
  end
end
