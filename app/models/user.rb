# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :rememberable

  attr_writer :login

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions).find_by("username = :value OR email = :value", value: login)
    elsif conditions[:username].nil?
      find_by(conditions)
    else
      find_by(username: conditions[:username])
    end
  end

  def login
    @login || username || email
  end
end
