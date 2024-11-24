class Store < ApplicationRecord
  has_many :orders, dependent: :nullify

  validates :url, format: URI::DEFAULT_PARSER.make_regexp(%w[http https]), if: -> { url.present? }

  after_commit :clear_default_store_cache

  before_save :ensure_default_exists_and_is_unique
  before_destroy -> { throw(:abort) }, if: :default?

  def default? = is_default

  def self.default
    Rails.cache.fetch("store_default") do
      Store.where(is_default: true).first
    end
  end

  private

  def clear_default_store_cache
    Rails.cache.delete("store_default")
  end

  def ensure_default_exists_and_is_unique
    if default?
      Store.where.not(id: id).update_all(is_default: false)
    elsif Store.where(is_default: true).count == 0
      self.is_default = true
    end
  end
end
