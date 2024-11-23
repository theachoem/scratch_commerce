class Product < ApplicationRecord
  extend FriendlyId

  include SoftDeletable

  friendly_id :name, use: :history

  enum :status, [ :draft, :active, :archived ], default: :draft

  belongs_to :merchant

  has_many :variants, -> { order(:position) }

  has_many :option_type_products, -> { order(:position) }, dependent: :destroy
  has_many :option_types, through: :option_type_products

  has_many :taxon_products, -> { order(:position) }, dependent: :destroy
  has_many :taxons, through: :taxon_products

  has_many :product_properties, -> { order(:position) }, dependent: :destroy
  has_many :properties, through: :product_properties

  validates_presence_of :name
  validates_presence_of :status
  validates_presence_of :merchant
  validates :slug, presence: true, uniqueness: true

  before_validation :normalize_slug, on: :update

  private

  def normalize_slug
    self.slug = normalize_friendly_id(name)
  end
end
