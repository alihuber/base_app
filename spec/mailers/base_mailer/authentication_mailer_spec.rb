require "spec_helper"

module BaseMailer
  describe AuthenticationMailer do
    let(:data) { OpenStruct.new(reset_link: "http://foo.bar") }
    let(:mail) { described_class.request_password_reset(
                      "test@example.com", data) }

    describe "#request_password_reset" do
      it "sends the mail from the system address" do
        expect(mail.from).to eq ["system@base_app.com"]
      end

      it "sends the mail to the given recipient" do
        expect(mail.to).to eq ["test@example.com"]
      end

      it "has a generic subject" do
        expect(mail.subject).to eq "Link Passwortreset"
      end

      it "contains the correct data" do
        expect(mail.body.parts[1].body.raw_source)
          .to(include "http://foo.bar")
      end
    end
  end
end
