# frozen_string_literal: true

module API
  module V1
    class CustomerParams
      include ActiveModel::Model

      attr_accessor :name,
                    :address,
                    :zip_code

      validates :name,     presence: true
      validates :address,  presence: true
      validates :zip_code, presence: true, length: { is: 5 }

      def self.build params
        customer_params = new(params)
        customer_params.validate_params
        customer_params.attributes
      end

      def validate_params
        return if valid?

        raise API::V1::BadRequest.new(missing_params.to_sentence) if missing_params.any?
        raise API::V1::UnprocessableEntity.new(errors.to_h)       if errors.any?
      end

      def attributes
        {
          name: name,
          address: address,
          zip_code: zip_code,
        }
      end

      private

      def missing_params
        errors.map { |k,v| k if v =~ /can\'t be blank/ }.compact
      end
    end
  end
end
