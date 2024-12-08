require "number_generator"

class Order < ApplicationRecord
  enum :state, { cart: 0, address: 1, payment: 2, completed: 3 }, default: :cart

  belongs_to :user, optional: true
  belongs_to :store, optional: false

  has_many :line_items, dependent: :destroy
  has_many :shipments, dependent: :destroy

  has_many :adjustments, -> { order(:created_at) }, as: :adjustable, inverse_of: :adjustable, dependent: :destroy
  has_many :line_item_adjustments, through: :line_items, source: :adjustments
  has_many :shipment_adjustments, through: :shipments, source: :adjustments

  has_many :all_adjustments, dependent: :destroy, class_name: Adjustment.name, inverse_of: :order

  belongs_to :billing_address, foreign_key: :billing_address_id, class_name: Address.name, optional: true
  belongs_to :shipping_address, foreign_key: :shipping_address_id, class_name: Address.name, optional: true

  belongs_to :approver, class_name: User.name, optional: true
  belongs_to :canceler, class_name: User.name, optional: true

  validates :email, presence: true, if: :email_required?
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, if: :email_required?
  validates :guest_token, uniqueness: true, presence: true
  validates :number, presence: true, uniqueness: { case_sensitive: true }

  before_validation :associate_default_store, if: -> { store_id.blank? }
  before_validation :set_currency, if: -> { currency.blank? }
  before_validation :set_channel, if: -> { channel.blank? }

  before_validation :generate_order_number, on: :create
  before_validation :create_token, on: :create
  before_validation :link_by_email, on: :create

  def email_required?
    false
  end

  def allowed_modify_item?
    cart? || address?
  end

  private

  def generate_order_number
    self.number ||= NumberGenerator.new(length: 8, prefix: "R").generate
  end

  def create_token
    self.guest_token ||= loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless self.class.exists?(guest_token: random_token)
    end
  end

  def associate_default_store
    self.store ||= Store.default
  end

  def set_currency
    self.currency ||= store.default_currency
  end

  def set_channel
    self.channel ||= "default"
  end

  def link_by_email
    self.email = user.email if user.present?
  end
end
