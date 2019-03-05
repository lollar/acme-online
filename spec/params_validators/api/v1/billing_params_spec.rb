# frozen_string_literal: true

require "rails_helper"

RSpec.describe ::API::V1::BillingParams do
  subject(:billing_params) { described_class.build params }

  describe ".build" do
    context "when valid parameters are provided" do
      let(:params) do
        {
          card_number: "1234567890123456",
          cvv: "123",
          expiration_month: "01",
          expiration_year: "2012",
          zip_code: "12345",
        }
      end

      specify { expect(billing_params).to eq params }
    end

    context "when parameters are missing required values" do
      let(:params) { { card_number: "1234567890123456" } }

      specify { expect{ billing_params }.to raise_error ::API::V1::BadRequest }
    end

    context "when parameters provided have invalid values" do
      let(:params) do
        {
          card_number: "1234567890123456",
          cvv: "123",
          expiration_month: "01",
          expiration_year: "12",
          zip_code: "12345",
        }
      end

      specify { expect{ billing_params }.to raise_error ::API::V1::UnprocessableEntity }
    end
  end
end
