# frozen_string_literal: true

class ResubscribesCustomer
  def self.resubscribe date: Date.today
    new(date).resubscribe
  end

  def initialize date
    @date = date
  end

  def resubscribe
    build_query_string
      .then(&method(:find_targets))
      .then(&method(:build_payload))
      .then(&method(:charge_customers))
  end

  private

  attr_reader :date

  def build_query_string
    if date == date.end_of_month
      "due_on >= #{date.day}"
    else
      "due_on = #{date.day}"
    end
  end

  def find_targets query
    ::Subscription
      .joins(:customer)
      .joins(:plan)
      .where("subscriptions.#{query}")
      .where("subscriptions.created_at::date != now()::date")
      .pluck("customers.card_token", "plans.price")
  end

  def build_payload values
    values.map{ |v| { token: v.first, amount: v.last } }
  end

  def charge_customers payloads
    puts "Charging #{payloads.count} customers due on the #{date.day.ordinalize}"

    payloads.each_slice(100) do |batch|
      batch.each do |payload|
        puts "Running charge for #{payload[:amount]}"
        ::External::FakepayRequest.call payload
      end
    end
  end
end
