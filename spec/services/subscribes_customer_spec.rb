# frozen_string_literal: true

require "rails_helper"

RSpec.describe ::SubscribesCustomer do
  subject(:subscribes_customer) { described_class.subscribe params }

  describe ".subscribe" do
    let(:plan) { ::Plan.find_by name: "Bronze Box" }
    let(:customer_params) do
      {
        name: "Bob Loblaw",
        address: "123 N Main St",
        zip_code: "00832",
      }
    end

    let(:billing_params) do
      {
        card_number: "4242424242424242",
        expiration_month: "01",
        expiration_year: "2024",
        cvv: "123",
        zip_code: "10045"
      }
    end

    context "when billing params are provided", vcr: { cassette_name: "new_subscribes_customer" } do
      let(:params) do
        {
          customer: customer_params,
          billing: billing_params,
          plan_id: plan.id
        }
      end

      specify { expect(subscribes_customer[:status]).to eq :created }
    end

    context "when no billing params are provided" do
      let(:params) do
        {
          plan_id: plan.id,
          customer: customer_params
        }
      end

      before do
        customer = ::Customer.create! customer_params.merge(card_token: SecureRandom.hex(13))
        allow(::External::FakepayRequest)
          .to receive(:call)
          .and_return({ "token" => SecureRandom.hex(13), "success" => true })
      end

      specify { expect(subscribes_customer[:status]).to eq :created }
    end

    context "when both billing params and customer has a card_token", vcr: { cassette_name: "resubscribes_customer" } do
      let(:params) do
        {
          plan_id: plan.id,
          customer: customer_params,
          billing: billing_params
        }
      end

      before do
        customer = ::Customer.create! customer_params.merge(card_token: SecureRandom.hex(13))
      end

      specify { expect(subscribes_customer[:status]).to eq :created }
    end

    context "when neither billing params or card token are present" do
      let(:params) do
        {
          plan_id: plan.id,
          customer: customer_params
        }
      end

      specify { expect{ subscribes_customer }.to raise_error ::API::V1::BadRequest }
    end
  end
end
