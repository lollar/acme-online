# frozen_string_literal: true

require "vcr"

VCR.configure do |c|
  c.cassette_library_dir = "spec/cassettes"
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.default_cassette_options = { record: ENV.fetch("VCR", "once").to_sym }
end
