# frozen_string_literal: true

class SubscribesCustomer
  def self.subscribe params
    new(params).subscribe
  end

  attr_reader :params

  delegate :billing_params, :customer_params, to: :params

  def initialize request_params
    @params = ::API::V1::SubscriptionParams.new request_params
    @plan   = ::Plan.find params.plan_id
  end

  def subscribe
    create_charge
      .then(&method(:process_response))
      .then(&method(:create_customer))
      .then(&method(:create_subscription))
      .then(&method(:process_result))
  end

  private

  attr_reader :plan

  def create_charge
    ::External::FakepayRequest.call billing_params.merge(amount: plan.price)
  end

  def process_response body
    raise ::API::V1::UnprocessableEntity.new(body["error_message"]) unless body["success"]

    body["token"]
  end

  def create_customer card_token
    ::Customer.find_or_create_by customer_params.merge(card_token: card_token)
  end

  def create_subscription customer
    ::Subscription.create! due_on: Date.today.day, customer: customer, plan: plan
  end

  def process_result subscription
    ::API::V1::Created.new(
      data: subscription,
      location: "/api/v1/subscriptions/#{subscription.id}"
    ).result
  end
end
