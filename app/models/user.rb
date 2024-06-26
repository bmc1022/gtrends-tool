# frozen_string_literal: true

class User < ApplicationRecord
  # Allow only a single role assignment.
  rolify before_add: :remove_existing_roles

  # Enable specified Devise modules.
  devise :database_authenticatable, :rememberable

  before_create :assign_default_role

  has_many :gtrends, dependent: :destroy

  attr_writer :login

  validates :username,
    uniqueness:   { case_sensitive: false,
                    allow_blank: true,
                    message: "The username '%{value}' is already in use, please try another" },
    length:       { in: 2..100,
                    allow_nil: true,
                    message: "Username should be between 2 to 100 characters" }
  validates :email,
    uniqueness:   { case_sensitive: false,
                    allow_blank: true,
                    message: "The email address '%{value}' is already in use, please try another" },
    length:       { in: 4..254,
                    allow_nil: true,
                    message: "Email address should be between 4 to 254 characters" },
    format:       { with: URI::MailTo::EMAIL_REGEXP,
                    allow_nil: true,
                    message: "'%{value}' is not a valid email format" }
  validates :password,
    presence:     { message: "A password is required" },
    length:       { in: 6..128,
                    message: "Your password should be between 6 to 128 characters" },
    confirmation: { message: "Password confirmation does not match" }
  validates :password_confirmation,
    presence:     { message: "Password confirmation is required" },
    length:       { maximum: 128,
                    message: "Password confirmation should not exceed 128 characters" }
  validate  :presence_of_username_or_email
  validate  :role_assigned, on: :update

  # Monkeypatched Devise method.
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    username_condition = conditions[:username]

    if (login = conditions.delete(:login))
      where(conditions).find_by("username = :value OR email = :value", value: login)
    elsif username_condition.nil?
      find_by(conditions)
    else
      find_by(username: username_condition)
    end
  end

  def login
    @login || username || email
  end

  private

  def remove_existing_roles(_)
    roles.delete_all
  end

  def assign_default_role
    add_role(:registered) if roles.blank?
  end

  def role_assigned
    errors.add(:user, "User must be assigned a role") if roles.blank?
  end

  def presence_of_username_or_email
    return if username.present? || email.present?

    errors.add(:base, "A user must have either a username or an email.")
  end
end
