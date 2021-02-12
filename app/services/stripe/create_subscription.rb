# frozen_string_literal: true

class Stripe::CreateSubscription
  include Interactor

  def call
    trial_end = context.subscription.trial_period_days.present? ? context.subscription.trial_period_days.day.after.to_i : nil
    subscription = Stripe::Subscription.create(
      {
        customer: context.stripe_customer_id,
        items: [
          {
            trial_end: trial_end,
            price: context.subscription.stripe_price_id
          }
        ],
        default_payment_method: context.stripe_card_id
      }
    )
    context.subscription = subscription
  rescue StandardError => e
    context.fail!(error: e)
  end
end
