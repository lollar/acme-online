# frozen_string_literal: true

module API
  module V1
    class BillingParams
      include ActiveModel::Model

      attr_accessor :card_number,
                    :cvv,
                    :expiration_month,
                    :expiration_year,
                    :zip_code

      validates :card_number, presence: true, length: { is: 16 }
      validates :cvv, presence: true, length: { is: 3 }
      validates :expiration_month, presence: true, length: { is: 2 }
      validates :expiration_year, presence: true, length: { is: 4 }
      validates :zip_code, presence: true, length: { is: 5 }

      def self.build params
        billing_params = new(params)
        billing_params.validate_params
        billing_params.attributes
      end

      def validate_params
        return if valid?

        raise API::V1::BadRequest.new(missing_params.to_sentence) if missing_params.any?
        raise API::V1::UnprocessableEntity.new(errors.to_h)       if errors.any?
      end

      def attributes
        {
          card_number: card_number,
          cvv: cvv,
          expiration_month: expiration_month,
          expiration_year: expiration_year,
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
