# frozen_string_literal: true

require "rails_helper"

RSpec.describe "[POST] /api/v1/subscriptions" do
  subject(:create_subscription) { post "/api/v1/subscriptions", params: params }

  let(:plan) { Plan.find_by name: "Bronze Box" }

  context "when valid data is provided", vcr: { cassette_name: "successful_post_subscriptions" } do
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
      create_subscription

      data = JSON.parse(response.body).fetch("data", {}).deep_symbolize_keys

      expect(response).to have_http_status :created
      expect(data.keys).to contain_exactly :id, :customer_id, :plan_id, :due_on
    end
  end

  context "when invalid data is provided", vcr: { cassette_name: "invalid_post_subscriptions" } do
    let(:params) do
      {
        plan_id: plan.id,
        customer: {
          name: "bob loblaw",
          address: "123 n main st",
          zip_code: "00832",
        },
        billing: {
          card_number: "4242424242424242",
          expiration_month: "01",
          expiration_year: "2024",
          cvv: "101",
          zip_code: "10045"
        }
      }
    end

    it "returns :created status" do
      create_subscription

      errors = JSON.parse(response.body).fetch("errors", "")

      expect(response).to have_http_status :unprocessable_entity
      expect(errors).to match /cvv/
    end
  end

  context "when missing data is provided", vcr: { cassette_name: "missing_post_subscriptions" } do
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
          expiration_year: "2024",
          cvv: "101",
          zip_code: "10045"
        }
      }
    end

    it "returns :created status" do
      create_subscription

      errors = JSON.parse(response.body).fetch("errors", "")

      expect(response).to have_http_status :bad_request
      expect(errors).to match /expiration_month/
    end
  end
end
