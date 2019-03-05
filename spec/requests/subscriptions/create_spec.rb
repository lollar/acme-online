# frozen_string_literal: true

require "rails_helper"

RSpec.describe "[POST] /api/v1/subscriptions" do
  subject(:create_subscription) { "/api/v1/subscriptions" }

  context "when valid data is provided", vcr: { cassette_name: "successful_post_subscriptions" } do
    let(:plan) { Plan.find_by name: "Bronze Box" }
    let(:params) do
      {
        plan_id: plan.id,
        customer: {
          name: "Bob Loblaw",
          address: "123 N Main St",
          zip_code: "00832",
        },
        billing: {
          card_number: "4242424242424242",
          expiration_month: "01",
          expiration_year: "2024",
          cvv: "123",
          zip_code: "10045"
        }
      }
    end

    it "returns :created status" do
      post create_subscription, params: params

      data = JSON.parse(response.body).fetch("data", {}).deep_symbolize_keys

      expect(response).to have_http_status :created
      expect(data.keys).to contain_exactly :id, :customer_id, :plan_id, :due_on
    end
  end
end
