defmodule Manatee.ProductsTest do
  use Manatee.DataCase

  alias Manatee.Products

  describe "products" do
    alias Manatee.Products.Product

    @valid_attrs %{ingredients: "some ingredients", interval: 42, interval_unit: "some interval_unit", name: "some name", rate: 120.5, rate_unit: "some rate_unit"}
    @update_attrs %{ingredients: "some updated ingredients", interval: 43, interval_unit: "some updated interval_unit", name: "some updated name", rate: 456.7, rate_unit: "some updated rate_unit"}
    @invalid_attrs %{ingredients: nil, interval: nil, interval_unit: nil, name: nil, rate: nil, rate_unit: nil}

    def product_fixture(attrs \\ %{}) do
      {:ok, product} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Products.create_product()

      product
    end

    test "list_products/0 returns all products" do
      product = product_fixture()
      assert Products.list_products() == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert Products.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      assert {:ok, %Product{} = product} = Products.create_product(@valid_attrs)
      assert product.ingredients == "some ingredients"
      assert product.interval == 42
      assert product.interval_unit == "some interval_unit"
      assert product.name == "some name"
      assert product.rate == 120.5
      assert product.rate_unit == "some rate_unit"
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Products.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()
      assert {:ok, %Product{} = product} = Products.update_product(product, @update_attrs)
      assert product.ingredients == "some updated ingredients"
      assert product.interval == 43
      assert product.interval_unit == "some updated interval_unit"
      assert product.name == "some updated name"
      assert product.rate == 456.7
      assert product.rate_unit == "some updated rate_unit"
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Products.update_product(product, @invalid_attrs)
      assert product == Products.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Products.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Products.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Products.change_product(product)
    end
  end
end
