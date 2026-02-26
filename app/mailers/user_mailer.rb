class UserMailer < ApplicationMailer
  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: "Bienvenue sur Eventbrite Lyon !")
  end

  def new_attendance_email(attendance)
    @attendance = attendance
    @event = attendance.event
    @attendee = attendance.user
    @organizer = @event.user
    mail(to: @organizer.email, subject: "Nouvelle inscription à votre événement : #{@event.title}")
  end

  def event_validated_email(event)
    @event = event
    @organizer = event.user
    mail(to: @organizer.email, subject: "Votre événement « #{@event.title} » a été validé !")
  end

  def event_rejected_email(event)
    @event = event
    @organizer = event.user
    mail(to: @organizer.email, subject: "Votre événement « #{@event.title} » a été refusé")
  end
end
