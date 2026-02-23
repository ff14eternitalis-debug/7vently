class Attendance < ApplicationRecord
  belongs_to :user
  belongs_to :event

  after_create :notify_organizer

  private

  def notify_organizer
    UserMailer.new_attendance_email(self).deliver_now
  end
end
