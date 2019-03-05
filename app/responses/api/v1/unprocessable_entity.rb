# frozen_string_literal: true

module API
  module V1
    class UnprocessableEntity < StandardError
      def initialize errors = {}
        @errors = errors
      end

      def result
        {
          json: { errors: "#{errors} is/are invalid" },
          status: :unprocessable_entity
        }
      end

      private

      attr_reader :errors
    end
  end
end
