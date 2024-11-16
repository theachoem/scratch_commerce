require "test_helper"

class ProductTest < ActiveSupport::TestCase
  class FriendlyId < ProductTest
    test "should generate a friendly ID slug from name" do
      product = Product.create!(name: "Test Product")
      assert_equal "test-product", product.slug
    end

    test "should update slug when name changes and track slug history" do
      product = Product.create!(name: "Test Product")
      assert_equal "test-product", product.slug

      product.update!(name: "Updated Product")
      new_slug = product.slug

      assert_equal "updated-product", new_slug
      assert_equal product, Product.friendly.find("test-product")
    end

    test "should find record by friendly ID" do
      product = Product.create!(name: "Test Product")
      found_product = Product.friendly.find(product.slug)
      assert_equal product, found_product
    end
  end

  class Enum < ProductTest
    test "has default status of draft" do
      product = Product.create!(name: "Test Product")
      assert_equal "draft", product.status
    end

    test "allows valid status transition" do
      product = Product.create!(name: "Test Product")
      product.update!(status: :active)
      assert_equal "active", product.status
    end

    test "raises error for invalid status" do
      assert_raises ArgumentError do
        Product.create!(name: "Invalid Status", status: :invalid_status)
      end
    end
  end
end
