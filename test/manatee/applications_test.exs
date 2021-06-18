defmodule Manatee.ApplicationsTest do
  use Manatee.DataCase

  alias Manatee.Applications

  describe "applications" do
    alias Manatee.Applications.Application

    @valid_attrs %{applied_at: "2010-04-17T14:00:00Z", description: "some description"}
    @update_attrs %{applied_at: "2011-05-18T15:01:01Z", description: "some updated description"}
    @invalid_attrs %{applied_at: nil, description: nil}

    def application_fixture(attrs \\ %{}) do
      {:ok, application} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Applications.create_application()

      application
    end

    test "list_applications/0 returns all applications" do
      application = application_fixture()
      assert Applications.list_applications() == [application]
    end

    test "get_application!/1 returns the application with given id" do
      application = application_fixture()
      assert Applications.get_application!(application.id) == application
    end

    test "create_application/1 with valid data creates a application" do
      assert {:ok, %Application{} = application} = Applications.create_application(@valid_attrs)
      assert application.applied_at == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert application.description == "some description"
    end

    test "create_application/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Applications.create_application(@invalid_attrs)
    end

    test "update_application/2 with valid data updates the application" do
      application = application_fixture()
      assert {:ok, %Application{} = application} = Applications.update_application(application, @update_attrs)
      assert application.applied_at == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert application.description == "some updated description"
    end

    test "update_application/2 with invalid data returns error changeset" do
      application = application_fixture()
      assert {:error, %Ecto.Changeset{}} = Applications.update_application(application, @invalid_attrs)
      assert application == Applications.get_application!(application.id)
    end

    test "delete_application/1 deletes the application" do
      application = application_fixture()
      assert {:ok, %Application{}} = Applications.delete_application(application)
      assert_raise Ecto.NoResultsError, fn -> Applications.get_application!(application.id) end
    end

    test "change_application/1 returns a application changeset" do
      application = application_fixture()
      assert %Ecto.Changeset{} = Applications.change_application(application)
    end
  end

  describe "application_products" do
    alias Manatee.Applications.ApplicationProduct

    @valid_attrs %{interval: 42, interval_unit: "some interval_unit", rate: 120.5, rate_unit: "some rate_unit"}
    @update_attrs %{interval: 43, interval_unit: "some updated interval_unit", rate: 456.7, rate_unit: "some updated rate_unit"}
    @invalid_attrs %{interval: nil, interval_unit: nil, rate: nil, rate_unit: nil}

    def application_product_fixture(attrs \\ %{}) do
      {:ok, application_product} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Applications.create_application_product()

      application_product
    end

    test "list_application_products/0 returns all application_products" do
      application_product = application_product_fixture()
      assert Applications.list_application_products() == [application_product]
    end

    test "get_application_product!/1 returns the application_product with given id" do
      application_product = application_product_fixture()
      assert Applications.get_application_product!(application_product.id) == application_product
    end

    test "create_application_product/1 with valid data creates a application_product" do
      assert {:ok, %ApplicationProduct{} = application_product} = Applications.create_application_product(@valid_attrs)
      assert application_product.interval == 42
      assert application_product.interval_unit == "some interval_unit"
      assert application_product.rate == 120.5
      assert application_product.rate_unit == "some rate_unit"
    end

    test "create_application_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Applications.create_application_product(@invalid_attrs)
    end

    test "update_application_product/2 with valid data updates the application_product" do
      application_product = application_product_fixture()
      assert {:ok, %ApplicationProduct{} = application_product} = Applications.update_application_product(application_product, @update_attrs)
      assert application_product.interval == 43
      assert application_product.interval_unit == "some updated interval_unit"
      assert application_product.rate == 456.7
      assert application_product.rate_unit == "some updated rate_unit"
    end

    test "update_application_product/2 with invalid data returns error changeset" do
      application_product = application_product_fixture()
      assert {:error, %Ecto.Changeset{}} = Applications.update_application_product(application_product, @invalid_attrs)
      assert application_product == Applications.get_application_product!(application_product.id)
    end

    test "delete_application_product/1 deletes the application_product" do
      application_product = application_product_fixture()
      assert {:ok, %ApplicationProduct{}} = Applications.delete_application_product(application_product)
      assert_raise Ecto.NoResultsError, fn -> Applications.get_application_product!(application_product.id) end
    end

    test "change_application_product/1 returns a application_product changeset" do
      application_product = application_product_fixture()
      assert %Ecto.Changeset{} = Applications.change_application_product(application_product)
    end
  end
end
