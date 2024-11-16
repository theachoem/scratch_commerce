class Taxon < ApplicationRecord
  acts_as_list scope: :taxonomy

  belongs_to :taxonomy
  belongs_to :parent, class_name: Taxon.name, optional: true, inverse_of: :children

  has_many :children, class_name: Taxon.name, inverse_of: :parent
  has_many :taxon_products
  has_many :products, through: :taxon_products

  validates :taxonomy, presence: true
  validates :name, presence: true
  validates :name, uniqueness: { scope: :parent_id, message: :must_be_unique_under_same_parent }

  before_validation :set_taxonomy

  before_save :set_permalink

  after_update :update_child_permalinks!, if: :saved_change_to_permalink?

  def set_permalink
    base_permalink = parent&.permalink
    self.permalink = [ base_permalink, name.parameterize ].compact.join("/")
  end

  def set_taxonomy
    self.taxonomy = parent&.taxonomy if parent.present?
  end

  def update_permalinks!
    set_permalink
    save!
  end

  def update_child_permalinks!
    children.each(&:update_permalinks!)
  end
end
