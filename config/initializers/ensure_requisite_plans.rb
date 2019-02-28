# frozen_string_literal: true

::Plan.find_or_create_by(name: "Bronze Box", price: 1999)
::Plan.find_or_create_by(name: "Silver Box", price: 4900)
::Plan.find_or_create_by(name: "Gold Box", price: 9900)
