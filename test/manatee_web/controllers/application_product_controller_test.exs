defmodule ManateeWeb.ApplicationProductControllerTest do
  use ManateeWeb.ConnCase

  alias Manatee.Applications
  alias Manatee.Applications.ApplicationProduct

  @create_attrs %{
    interval: 42,
    interval_unit: "some interval_unit",
    rate: 120.5,
    rate_unit: "some rate_unit"
  }
  @update_attrs %{
    interval: 43,
    interval_unit: "some updated interval_unit",
    rate: 456.7,
    rate_unit: "some updated rate_unit"
  }
  @invalid_attrs %{interval: nil, interval_unit: nil, rate: nil, rate_unit: nil}

  def fixture(:application_product) do
    {:ok, application_product} = Applications.create_application_product(@create_attrs)
    application_product
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all application_products", %{conn: conn} do
      conn = get(conn, Routes.application_product_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create application_product" do
    test "renders application_product when data is valid", %{conn: conn} do
      conn = post(conn, Routes.application_product_path(conn, :create), application_product: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.application_product_path(conn, :show, id))

      assert %{
               "id" => id,
               "interval" => 42,
               "interval_unit" => "some interval_unit",
               "rate" => 120.5,
               "rate_unit" => "some rate_unit"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.application_product_path(conn, :create), application_product: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update application_product" do
    setup [:create_application_product]

    test "renders application_product when data is valid", %{conn: conn, application_product: %ApplicationProduct{id: id} = application_product} do
      conn = put(conn, Routes.application_product_path(conn, :update, application_product), application_product: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.application_product_path(conn, :show, id))

      assert %{
               "id" => id,
               "interval" => 43,
               "interval_unit" => "some updated interval_unit",
               "rate" => 456.7,
               "rate_unit" => "some updated rate_unit"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, application_product: application_product} do
      conn = put(conn, Routes.application_product_path(conn, :update, application_product), application_product: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete application_product" do
    setup [:create_application_product]

    test "deletes chosen application_product", %{conn: conn, application_product: application_product} do
      conn = delete(conn, Routes.application_product_path(conn, :delete, application_product))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.application_product_path(conn, :show, application_product))
      end
    end
  end

  defp create_application_product(_) do
    application_product = fixture(:application_product)
    %{application_product: application_product}
  end
end
