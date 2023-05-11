# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :rememberable

  has_many :gtrends, dependent: :destroy

  attr_writer :login

  validates :username, uniqueness: { case_sensitive: false, allow_blank: true }
  validates :email, uniqueness: { case_sensitive: false, allow_blank: true }
  validate  :username_or_email

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

  def username_or_email
    return if username.present? || email.present?

    errors.add(:base, "A user must have either a username or an email.")
  end
end
