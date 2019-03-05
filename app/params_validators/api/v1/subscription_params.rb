# frozen_string_literal: true

module API
  module V1
    class SubscriptionParams
      def self.build params
        new(params)
      end

      attr_reader :billing_params, :customer_params, :plan_id

      def initialize params
        @billing_params  = ::API::V1::BillingParams.build params.fetch(:billing, {})
        @customer_params = ::API::V1::CustomerParams.build params.fetch(:customer, {})
        @plan_id         = params.fetch(:plan_id) { raise ::API::V1::BadRequest.new :plan_id }
      end
    end
  end
end
