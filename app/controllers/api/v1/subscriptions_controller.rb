# frozen_string_literal: true

module API
  module V1
    class SubscriptionsController < ApplicationController
      def create
        customer = Customer.find_or_create_by customer_params
        customer.update(card_token: tokenize_card)
        plan = Plan.find params[:plan_id]

        sub = ::Subscription.create! due_on: Date.today.day, customer: customer, plan: plan

        render json: { data: sub }, status: :created, location: "subscriptions_path"
      end

      private

      def customer_params
        params.require(:customer).permit(:name, :address, :zip_code)
      end

      def tokenize_card
        #TODO: Add HTTP library and build out external request
        SecureRandom.hex(13)
      end
    end
  end
end
