defmodule ManateeWeb.ProductLiveTest do
  use ManateeWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Manatee.Products

  @create_attrs %{ingredients: "some ingredients", interval: 42, interval_unit: "some interval_unit", name: "some name", rate: 120.5, rate_unit: "some rate_unit"}
  @update_attrs %{ingredients: "some updated ingredients", interval: 43, interval_unit: "some updated interval_unit", name: "some updated name", rate: 456.7, rate_unit: "some updated rate_unit"}
  @invalid_attrs %{ingredients: nil, interval: nil, interval_unit: nil, name: nil, rate: nil, rate_unit: nil}

  defp fixture(:product) do
    {:ok, product} = Products.create_product(@create_attrs)
    product
  end

  defp create_product(_) do
    product = fixture(:product)
    %{product: product}
  end

  describe "Index" do
    setup [:create_product]

    test "lists all products", %{conn: conn, product: product} do
      {:ok, _index_live, html} = live(conn, Routes.product_index_path(conn, :index))

      assert html =~ "Listing Products"
      assert html =~ product.ingredients
    end

    test "saves new product", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.product_index_path(conn, :index))

      assert index_live |> element("a", "New Product") |> render_click() =~
               "New Product"

      assert_patch(index_live, Routes.product_index_path(conn, :new))

      assert index_live
             |> form("#product-form", product: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#product-form", product: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.product_index_path(conn, :index))

      assert html =~ "Product created successfully"
      assert html =~ "some ingredients"
    end

    test "updates product in listing", %{conn: conn, product: product} do
      {:ok, index_live, _html} = live(conn, Routes.product_index_path(conn, :index))

      assert index_live |> element("#product-#{product.id} a", "Edit") |> render_click() =~
               "Edit Product"

      assert_patch(index_live, Routes.product_index_path(conn, :edit, product))

      assert index_live
             |> form("#product-form", product: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#product-form", product: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.product_index_path(conn, :index))

      assert html =~ "Product updated successfully"
      assert html =~ "some updated ingredients"
    end

    test "deletes product in listing", %{conn: conn, product: product} do
      {:ok, index_live, _html} = live(conn, Routes.product_index_path(conn, :index))

      assert index_live |> element("#product-#{product.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#product-#{product.id}")
    end
  end

  describe "Show" do
    setup [:create_product]

    test "displays product", %{conn: conn, product: product} do
      {:ok, _show_live, html} = live(conn, Routes.product_show_path(conn, :show, product))

      assert html =~ "Show Product"
      assert html =~ product.ingredients
    end

    test "updates product within modal", %{conn: conn, product: product} do
      {:ok, show_live, _html} = live(conn, Routes.product_show_path(conn, :show, product))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Product"

      assert_patch(show_live, Routes.product_show_path(conn, :edit, product))

      assert show_live
             |> form("#product-form", product: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#product-form", product: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.product_show_path(conn, :show, product))

      assert html =~ "Product updated successfully"
      assert html =~ "some updated ingredients"
    end
  end
end
