class User < ApplicationRecord
  has_many :attendances, dependent: :destroy
  has_many :participated_events, through: :attendances, source: :event
  has_many :organized_events, class_name: "Event", foreign_key: "user_id", dependent: :destroy

  after_create :send_welcome_email

  private

  def send_welcome_email
    UserMailer.welcome_email(self).deliver_now
  end
end
