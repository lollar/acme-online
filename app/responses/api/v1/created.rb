# frozen_string_literal: true

module API
  module V1
    class Created
      def initialize data:, location:
        @data     = data
        @location = location
      end

      def result
        {
          json: { data: data },
          location: location,
          status: :created,
        }
      end

      private

      attr_reader :data, :location
    end
  end
end
