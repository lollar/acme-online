# frozen_string_literal: true

require 'net/http'

module API
  module V1
    class SubscriptionsController < ApplicationController
      def create
        customer = Customer.find_or_create_by customer_params
        plan     = Plan.find params[:plan_id]
        customer.update(card_token: tokenize_card(plan).body["token"])
        sub = ::Subscription.create! due_on: Date.today.day, customer: customer, plan: plan

        render json: { data: sub }, status: :created, location: "subscriptions_path"
      end

      private

      def customer_params
        params.require(:customer).permit(:name, :address, :zip_code)
      end

      def billing_params
        params.require(:billing).permit(:card_number, :exp_date, :cvv, :zip_code)
      end

      def tokenize_card(plan)
        uri          = URI.parse("https://www.fakepay.io/purchase")
        conn         = Net::HTTP.new(uri.host, uri.port)
        conn.use_ssl = true
        request      = Net::HTTP::Post.new(uri.request_uri, fakepay_headers)
        request.set_form_data(fakepay_payload(plan))

        conn.request(request)
      end

      def fakepay_headers
        {
          "Authorization" => "Token token=#{ENV.fetch("FAKEPAY_AUTH_TOKEN")}",
          "Content-Type"  => "application/json"
        }
      end

      def fakepay_payload(plan)
        exp_month, exp_year = billing_params[:exp_date].split("/")

        {
          amount: plan.price,
          card_number: billing_params[:card_number],
          cvv: billing_params[:cvv],
          expiration_month: exp_month,
          expiration_year: exp_year,
          zip_code: billing_params[:zip_code],
        }
      end
    end
  end
end
