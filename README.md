# README

## Installation

- Ruby Version: 2.6.1
- Rails Version: 5.2.2

```
bundle install
bundle exec rake db:create
bundle exec rake db:schema:load
```

## Specs

First, in your chosen way, set the FAKEWAY_AUTH_TOKEN environment variable (I used export FAKEWAY_AUTH_TOKEN=my-token-here).

```
bundle exec rspec
```

This will run the spec suite with my current VCR cassettes. If you would like to re-record them with your auth token then you can simply run:

```
VCR=all bundle exec rspec
```

## API Usage
To create a new subscription see the sample payload and endpoint below. All parameters in the payload
are required for first time customers, or if the customer wants to use a new credit card.
```
[POST] /api/v1/subscriptions

{
  plan_id: plan.id,
  customer: {
    name: "Bob Loblaw",
    address: "123 N Main St",
    zip_code: "00832",
  },
  billing: {
    card_number: "4242424242424242",
    expiration_month: "01",
    expiration_year: "2024",
    cvv: "123",
    zip_code: "10045"
  }
}
```

If the customer has previously been subscribed to a product and does not want to use a different credit card, then you can send the payload without the billing parameters. This will use the customer's previous tokenized card to charge the customer.

## Bonus
A customer can have multiple subscriptions so long as their provided customer params are a 1-for-1 copy of their previously provided customer params. If they're using the subscribe endpoint there is no validation to ensure the customer isn't already subscribed to the product. If the customer chooses to subscribe to 42 bronze boxes then they can. Whether or not the customer is using a different credit card does not affect adding the subscription to the customer.

To run a cron job for resubscribing customers you can simply run a rake task like such:
```
bundle exec rake customers:resubscribe # This will run the resubscription for the current date
bundle exec rake customers:resubscribe["May 05 1999"] # This will run the resubscription for the 5th. The month doesn't matter
```

## Notes
One of the bigger questions is probably why I decided to go with just an integer field for due_on. I thought it kept it simpler, I've run into problems previously with dates so I decided to do this. I feel like with dates it gets weird because you run into things like the end of the month. If I subscribe on January 31st, my resubscription is going to run on the 28th (using simple rails logic) but then I'm going to update the next due date and it's going to be stuck on the 28th forever. Instead, I can simply check if I'm on the last day of the month and then grab every other date that is greater than that day or just for the day. This will never update the customer's due date. And the 29th will always be the 29th, except in February, where the vast majority of the time it will be on the 28th
