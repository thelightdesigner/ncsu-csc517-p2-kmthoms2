require "uri"

class Volunteer < ApplicationRecord
  has_many :volunteer_assignments, dependent: :destroy
  has_many :events, through: :volunteer_assignments

  validates :username, :password, :full_name, :email, presence: true
  validates :username, uniqueness: true
  validates :phone_number, length: { maximum: 20 }, allow_blank: true
  validates :phone_number, format: { with: /\A\d+\z/, message: "must contain only digits" }, allow_blank: true
  validate :email_is_valid_mailto

  def total_logged_hours
    volunteer_assignments.joins(:event).where(events: { status: Event.statuses[:completed] }).sum(:hours_worked).to_f
  end

  private

  def email_is_valid_mailto
    URI::MailTo.build([ nil, email ])
  rescue URI::InvalidComponentError, URI::Error
    errors.add(:email, "is invalid")
  end
end
