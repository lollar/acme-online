# frozen_string_literal: true

module API
  module V1
    class UnprocessableEntity < StandardError
      attr_reader :status, :errors

      def initialize errors = {}
        @status = :unprocessable_entity
        @errors = errors
      end
    end
  end
end
