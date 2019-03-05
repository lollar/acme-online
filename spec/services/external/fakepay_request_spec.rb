# frozen_string_literal: true

RSpec.describe ::External::FakepayRequest do
  subject(:fakepay_request) { described_class.call payload }

  describe ".call" do
    context "with successfully charged card", vcr: { cassette_name: "fakepay_request_success" } do
      let(:payload) do
        {
          amount: "1000",
          card_number: "4242424242424242",
          expiration_month: "01",
          expiration_year: "2024",
          cvv: "123",
          zip_code: "10045",
        }
      end

      it "returns successful result" do
        expect(fakepay_request["token"]).to be_present
        expect(fakepay_request["success"]).to be_truthy
        expect(fakepay_request["error_code"]).to be_nil
        expect(fakepay_request["error_message"]).to be_blank
      end
    end

    context "with invalid card number", vcr: { cassette_name: "fakepay_invalid_card" } do
      let(:payload) do
        {
          amount: "1000",
          card_number: "4242424242424241",
          expiration_month: "01",
          expiration_year: "2024",
          cvv: "123",
          zip_code: "10045",
        }
      end

      it "returns unsuccessful result" do
        expect(fakepay_request["token"]).to be_nil
        expect(fakepay_request["success"]).to be_falsey
        expect(fakepay_request["error_code"]).to eq 1000001
        expect(fakepay_request["error_message"]).to eq "credit card number"
      end
    end

    context "with insufficient funds", vcr: { cassette_name: "fakepay_insufficient_funds" } do
      let(:payload) do
        {
          amount: "1000",
          card_number: "4242424242420089",
          expiration_month: "01",
          expiration_year: "2024",
          cvv: "123",
          zip_code: "10045",
        }
      end

      it "returns unsuccessful result" do
        expect(fakepay_request["token"]).to be_nil
        expect(fakepay_request["success"]).to be_falsey
        expect(fakepay_request["error_code"]).to eq 1000002
        expect(fakepay_request["error_message"]).to eq "available funds"
      end
    end
  end
end
# {"token"=>nil, "success"=>false, "error_code"=>1000001, "error_message"=>""}
