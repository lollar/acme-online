# frozen_string_literal: true

require "rails_helper"

RSpec.describe "[POST] /api/v1/subscriptions" do
  subject(:create_subscription) { "/api/v1/subscriptions" }

  context "when valid data is provided" do
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
          card_number: "4111111111111111",
          exp_date: "07/19",
          cvv: "100",
          zip_code: "00835"
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
