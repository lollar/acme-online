# frozen_string_literal: true

require "net/http"

module External
  class FakepayRequest
    FAKEPAY_ERROR_CODES = {
      1000001 => "credit card number",
      1000002 => "available funds",
      1000003 => "cvv",
      1000004 => "expiration date",
      1000005 => "zip code",
      1000006 => "payment",
      1000007 => "payment",
      1000008 => "payment",
    }

    def self.call payload
      new.process_request payload
    end

    def process_request payload
      uri          = URI.parse "https://www.fakepay.io/purchase"
      conn         = Net::HTTP.new(uri.host, uri.port)
      conn.use_ssl = true
      request      = Net::HTTP::Post.new(uri.request_uri, headers)
      request.set_form_data(payload)

      parsed_response conn.request(request).body
    end

    private

    def headers
      {
        "Authorization" => "Token token=#{ENV.fetch("FAKEPAY_AUTH_TOKEN")}",
        "Content-Type"  => "application/json"
      }
    end

    def parsed_response body
      body = JSON.parse body
      body.merge "error_message" => FAKEPAY_ERROR_CODES.fetch(body["error_code"], "")
    end
  end
end
