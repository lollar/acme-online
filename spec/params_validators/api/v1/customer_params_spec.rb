# frozen_string_literal: true

require "rails_helper"

RSpec.describe API::V1::CustomerParams do
  subject(:customer_params) { described_class.build params }

  describe ".build" do
    context "when valid params are provided" do
      let(:params) do
        {
          name: "Bob Loblaw",
          address: "123 N Main St",
          zip_code: "13403"
        }
      end

      specify { expect(customer_params).to eq params }
    end

    context "when params are missing required keys" do
      let(:params) { {} }

      specify { expect{ customer_params }.to raise_error ::API::V1::BadRequest }
    end

    context "when params have invalid values" do
      let(:params) do
        {
          name: "Bob Loblaw",
          address: "1234 N Main St",
          zip_code: "123"
        }
      end

      specify { expect{ customer_params }.to raise_error ::API::V1::UnprocessableEntity }
    end
  end
end
