# frozen_string_literal: true

class Stripe::ChangeSubscriptionCard
  include Interactor

  def call
    subscription = Stripe::Subscription.update(
      context.stripe_subscription_id,
      {
        default_payment_method: context.stripe_card_id
      }
    )
    context.subscription = subscription
  rescue StandardError => e
    context.fail!(error: e)
  end
end
