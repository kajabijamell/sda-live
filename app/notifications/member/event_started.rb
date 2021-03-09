# To deliver this notification:
#
# EventStarted.with(post: @post).deliver_later(current_user)
# EventStarted.with(post: @post).deliver(current_user)

class EventStarted < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database
  deliver_by :email, mailer: 'MemberMailer', method: 'event_started'
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  # Add required params
  param :event


  # Define helper methods to make rendering easier.
  #
  # def message
  #   t(".message")
  # end
  #
  # def url
  #   post_path(params[:post])
  # end
end
