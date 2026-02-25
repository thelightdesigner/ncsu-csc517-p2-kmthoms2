class Admin < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[^@\s]+@[^@\s]+\.[^@\s]+\z/

  validates :username, :password, :full_name, :email, presence: true
  validates :email, format: { with: VALID_EMAIL_REGEX }
  validate :single_admin_record, on: :create

  before_destroy :prevent_destroy

  private

  def single_admin_record
    errors.add(:base, "Only one admin account is allowed") if Admin.exists?
  end

  def prevent_destroy
    errors.add(:base, "Admin account cannot be deleted")
    throw(:abort)
  end
end
