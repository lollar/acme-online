# frozen_string_literal: true

class Customer < ApplicationRecord
  has_many :subscriptions
end
