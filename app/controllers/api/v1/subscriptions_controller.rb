# frozen_string_literal: true

module API
  module V1
    class SubscriptionsController < ApplicationController
      def create
        render json: {
          data: {
            name: "Bronze Box",
            price: "4999"
          }
        }, status: :created
      end
    end
  end
end
