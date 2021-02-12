class SuperAdmin::SubscriptionsController < ApplicationController
  before_action :fetch_subscription, only: %i[edit update]

  def index
    @subscriptions = Subscription.order(:id)
  end

  def new
    @subscription = Subscription.new
  end

  def create
    @subscription = Subscription.new(subscription_params)
    if @subscription.valid?
      begin
        product = Stripe::Product.create({
                                           name: @subscription.name,
                                           metadata: { id: @subscription.id },
                                           active: @subscription.active
                                         })
        price = Stripe::Price.create({
                                       unit_amount: (@subscription.price * 100).round,
                                       currency: 'usd',
                                       recurring: { interval: 'month' },
                                       product: product.id,
                                       active: @subscription.active
                                     })
        @subscription.stripe_product_id = product.id
        @subscription.stripe_price_id = price.id
        @subscription.save
        flash[:notice] = 'Successful creation of subscription.'
        redirect_to super_admin_subscriptions_path
      rescue StandardError => e
        flash[:error] = e.message
        redirect_to super_admin_subscriptions_path
      end
    else
      render :new
    end
  end

  def update
    if @subscription.update(subscription_update_params)
      begin
        Stripe::Product.update(@subscription.stripe_product_id, { name: @subscription.name,
                                                                  active: @subscription.active })
        Stripe::Price.update(@subscription.stripe_price_id, { active: @subscription.active })
        redirect_to super_admin_subscriptions_path
      rescue StandardError => e
        flash[:error] = e.message
        redirect_back(fallback_location: super_admin_subscriptions_path)
      end
    else
      render :edit
    end
  end

  private

  def fetch_subscription
    @subscription = Subscription.find(params[:id])
  rescue ActiveRecord::RecordNotFound => _e
    flash[:error] = 'No subscription found'
    redirect_to super_admin_subscriptions_path
  end

  def subscription_params
    params.require(:subscription).permit(:name, :price, :live_streams, :stream_size, :targets, :video_storage,
                                         :viewer_count, :rank, :active, :trial_period_days)
  end

  def subscription_update_params
    params.require(:subscription).permit(:name, :live_streams, :stream_size, :targets, :video_storage,
                                         :viewer_count, :rank, :active, :trial_period_days)
  end
end
