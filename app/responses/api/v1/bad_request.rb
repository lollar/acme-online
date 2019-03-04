# frozen_string_literal: true

module API
  module V1
    class BadRequest < StandardError
      attr_reader :status, :errors

      def initialize errors = {}
        @status = :bad_request
        @errors = errors
      end
    end
  end
end
