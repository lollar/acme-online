# frozen_string_literal: true

module API
  module V1
    class BadRequest < StandardError
      def initialize errors = {}
        @errors = errors
      end

      def result
        {
          json: { errors: "#{errors} is/are required" },
          status: :bad_request
        }
      end

      private

      attr_reader :errors
    end
  end
end
