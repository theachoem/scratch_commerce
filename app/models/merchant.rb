class Merchant < ApplicationRecord
  extend FriendlyId
  include SoftDeletable

  friendly_id :name, use: :history

  enum :status, [ :draft, :active, :archived ], default: :draft

  has_many :products

  validates_presence_of :name
  validates_presence_of :status
  validates :slug, presence: true, uniqueness: true

  before_validation :normalize_slug, on: :update

  private

  def normalize_slug
    self.slug = normalize_friendly_id(name)
  end
end
