class CreateMerchantSchema < ActiveRecord::Migration[8.0]
  def change
    create_table :merchants do |t|
      t.string :name, null: false
      t.integer :status, default: 0, null: false
      t.decimal :commission_rate, default: 0, null: false
      t.string :slug, null: false, index: { unique: true }
      t.datetime :deleted_at, index: true

      t.timestamps
    end

    create_table :merchant_users do |t|
      t.references :user, null: false, foreign_key: true
      t.references :merchant, null: false, foreign_key: true

      t.timestamps
    end

    add_reference :products, :merchant, null: false, foreign_key: true
  end
end
