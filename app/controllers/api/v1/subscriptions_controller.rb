# frozen_string_literal: true

module API
  module V1
    class SubscriptionsController < ApplicationController
      def create
        render ::SubscribesCustomer.subscribe params
      end
    end
  end
end
