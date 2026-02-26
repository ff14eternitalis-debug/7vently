class AttendancesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event
  before_action :not_organizer_or_participant, only: [ :new, :create ]
  before_action :organizer_only, only: [ :index ]

  def new
    if @event.is_free?
      attendance = Attendance.create!(user: current_user, event: @event)
      redirect_to @event, notice: "Vous participez maintenant à cet événement !"
    else
      session = Stripe::Checkout::Session.create(
        payment_method_types: [ "card" ],
        line_items: [ {
          price_data: {
            currency: "eur",
            product_data: { name: @event.title },
            unit_amount: @event.price * 100
          },
          quantity: 1
        } ],
        mode: "payment",
        success_url: event_attendances_url(@event, session_id: "{CHECKOUT_SESSION_ID}"),
        cancel_url: event_url(@event)
      )
      redirect_to session.url, allow_other_host: true
    end
  end

  def create
    if @event.is_free?
      redirect_to @event, alert: "Cet événement est gratuit."
    else
      stripe_session = Stripe::Checkout::Session.retrieve(params[:session_id])

      if stripe_session.payment_status == "paid"
        Attendance.create!(
          user: current_user,
          event: @event,
          stripe_customer_id: stripe_session.customer
        )
        redirect_to @event, notice: "Paiement réussi ! Vous participez à l'événement."
      else
        redirect_to @event, alert: "Le paiement n'a pas abouti. Veuillez réessayer."
      end
    end
  end

  def index
    @attendances = @event.attendances.includes(:user).order(created_at: :asc)
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def not_organizer_or_participant
    if @event.user == current_user
      redirect_to @event, alert: "Vous êtes l'organisateur de cet événement."
    elsif @event.attendees.include?(current_user)
      redirect_to @event, alert: "Vous participez déjà à cet événement."
    end
  end

  def organizer_only
    unless @event.user == current_user
      redirect_to root_path, alert: "Accès non autorisé."
    end
  end
end
