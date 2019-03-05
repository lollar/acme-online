# frozen_string_literal: true

class SubscribesCustomer
  def self.subscribe params
    new(params).subscribe
  end

  attr_reader :params

  delegate :billing_params, :customer_params, to: :params

  def initialize request_params
    @params   = ::API::V1::SubscriptionParams.new request_params
    @plan     = ::Plan.find params.plan_id
    @customer = ::Customer.find_or_create_by customer_params
  end

  def subscribe
    build_payload
      .then(&method(:create_charge))
      .then(&method(:process_response))
      .then(&method(:update_customer_token))
      .then(&method(:create_subscription))
      .then(&method(:process_result))
  end

  private

  attr_reader :customer, :plan

  def build_payload
    raise ::API::V1::BadRequest.new(:billing) if billing_params.empty? && customer.card_token.nil?

    if billing_params.empty?
      { token: customer.card_token, amount: plan.price }
    else
      billing_params.merge(amount: plan.price)
    end
  end

  def create_charge payload
    ::External::FakepayRequest.call payload
  end

  def process_response body
    raise ::API::V1::UnprocessableEntity.new(body["error_message"]) unless body["success"]

    body["token"]
  end

  def update_customer_token token
    customer.update card_token: token
  end

  def create_subscription _
    customer.subscriptions.create! due_on: Date.today.day, plan: plan
  end

  def process_result subscription
    ::API::V1::Created.new(
      data: subscription,
      location: "/api/v1/subscriptions/#{subscription.id}"
    ).result
  end
end
