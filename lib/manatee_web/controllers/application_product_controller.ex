defmodule ManateeWeb.ApplicationProductController do
  use ManateeWeb, :controller

  alias Manatee.Applications
  alias Manatee.Applications.ApplicationProduct

  action_fallback ManateeWeb.FallbackController

  def index(conn, _params) do
    application_products = Applications.list_application_products()
    render(conn, "index.json", application_products: application_products)
  end

  def create(conn, %{"application_product" => application_product_params}) do
    with {:ok, %ApplicationProduct{} = application_product} <- Applications.create_application_product(application_product_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.application_product_path(conn, :show, application_product))
      |> render("show.json", application_product: application_product)
    end
  end

  def show(conn, %{"id" => id}) do
    application_product = Applications.get_application_product!(id)
    render(conn, "show.json", application_product: application_product)
  end

  def update(conn, %{"id" => id, "application_product" => application_product_params}) do
    application_product = Applications.get_application_product!(id)

    with {:ok, %ApplicationProduct{} = application_product} <- Applications.update_application_product(application_product, application_product_params) do
      render(conn, "show.json", application_product: application_product)
    end
  end

  def delete(conn, %{"id" => id}) do
    application_product = Applications.get_application_product!(id)

    with {:ok, %ApplicationProduct{}} <- Applications.delete_application_product(application_product) do
      send_resp(conn, :no_content, "")
    end
  end
end
