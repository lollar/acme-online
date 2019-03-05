namespace :customers do
  desc "Resubscribe customers USAGE: rake customers:resubscribe OR rake customers:resubscribe['Month DD YYYY']"
  task :resubscribe, [:date] => [:environment] do |t, args|
    date = args.key?(:date) ? Date.parse(args[:date]) : Date.today

    ::ResubscribesCustomer.resubscribe date: date
  end
end
