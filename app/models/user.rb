class User < ApplicationRecord
  has_secure_password

  has_many :sessions, dependent: :destroy
  has_many :merchant_users, dependent: :destroy
  has_many :merchants, through: :merchant_users

  validates :email, presence: true, uniqueness: true

  normalizes :email, with: ->(e) { e.strip.downcase }
end
