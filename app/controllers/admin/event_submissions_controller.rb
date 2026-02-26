class Admin::EventSubmissionsController < Admin::ApplicationController
  before_action :set_event, only: [ :show, :edit, :update ]

  def index
    @pending  = Event.pending_validation.includes(:user).order(created_at: :desc)
    @validated = Event.validated_events.includes(:user).order(created_at: :desc)
    @rejected  = Event.rejected_events.includes(:user).order(created_at: :desc)
  end

  def show
  end

  def edit
  end

  def update
    decision = params[:decision]
    case decision
    when "validate"
      @event.update!(validated: true)
      UserMailer.event_validated_email(@event).deliver_now
      redirect_to admin_event_submissions_path, notice: "Événement « #{@event.title} » validé ✅"
    when "reject"
      @event.update!(validated: false)
      UserMailer.event_rejected_email(@event).deliver_now
      redirect_to admin_event_submissions_path, notice: "Événement « #{@event.title} » refusé ❌"
    else
      redirect_to admin_event_submission_path(@event), alert: "Décision invalide."
    end
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end
end
