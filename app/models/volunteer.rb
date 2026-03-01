class Volunteer < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[^@\s]+@(?:localhost|(?:[A-Za-z0-9-]+\.)+[A-Za-z]{2,})\z/

  has_many :volunteer_assignments, dependent: :destroy
  has_many :events, through: :volunteer_assignments

  validates :username, :password, :full_name, :email, presence: true
  validates :username, uniqueness: true
  validates :email, format: { with: VALID_EMAIL_REGEX, message: "is invalid" }
  validates :phone_number, length: { maximum: 20 }, allow_blank: true
  validates :phone_number, format: { with: /\A\d+\z/, message: "must contain only digits" }, allow_blank: true

  def total_logged_hours
    volunteer_assignments.joins(:event).where(events: { status: Event.statuses[:completed] }).sum(:hours_worked).to_f
  end
end
