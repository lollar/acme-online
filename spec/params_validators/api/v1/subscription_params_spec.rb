# frozen_string_literal: true

require "rails_helper"

RSpec.describe ::API::V1::SubscriptionParams do
  subject(:subscription_params) { described_class.build params }

  let(:billing_params) { class_double("API::V1::BillingParams", build: {}).as_stubbed_const }
  let(:customer_params) { class_double("API::V1::CustomerParams", build: {}).as_stubbed_const }

  describe ".build" do
    context "when plan_id is provided" do
      let(:params) { { plan_id: 1, billing: {}, customer: {} } }

      it "returns params object" do
        allow(billing_params).to receive(:build)
        allow(customer_params).to receive(:build)
        expect(subscription_params.plan_id).to eq params[:plan_id]
      end
    end

    context "when plan_id is not provided" do
      let(:params) { {} }

      it "raises bad_request exception" do
        allow(billing_params).to receive(:build)
        allow(customer_params).to receive(:build)
        expect{ subscription_params }.to raise_error ::API::V1::BadRequest
      end
    end
  end
end
