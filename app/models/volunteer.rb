class Volunteer < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[^@\s]+@[^@\s]+\.[^@\s]+\z/

  has_many :volunteer_assignments, dependent: :destroy
  has_many :events, through: :volunteer_assignments

  validates :username, :password, :full_name, :email, presence: true
  validates :username, uniqueness: true
  validates :email, format: { with: VALID_EMAIL_REGEX }

  def total_logged_hours
    volunteer_assignments.sum(:hours_worked).to_f
  end
end
