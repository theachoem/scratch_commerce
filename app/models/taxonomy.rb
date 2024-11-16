class Taxonomy < ApplicationRecord
  acts_as_list

  has_many :taxons

  validates :name, presence: true
  validates :name, uniqueness: true
end
