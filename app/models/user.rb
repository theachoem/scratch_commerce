class User < ApplicationRecord
  has_secure_password

  has_many :sessions, dependent: :destroy
  has_many :merchant_users
  has_many :merchants, through: :merchant_users

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
