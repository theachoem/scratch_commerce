class Merchant < ApplicationRecord
  extend FriendlyId
  include SoftDeletable

  friendly_id :name, use: :history

  enum :status, [ :draft, :active, :archived ], default: :draft

  has_many :merchant_users
  has_many :users, through: :merchant_users
  has_many :products

  validates_presence_of :name
  validates_presence_of :status
  validates_presence_of :commission_rate
  validates :slug, presence: true, uniqueness: true
  validates :commission_rate, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  before_validation :normalize_slug, on: :update

  private

  def normalize_slug
    self.slug = normalize_friendly_id(name)
  end
end
