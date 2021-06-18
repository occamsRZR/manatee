defmodule ManateeWeb.ApplicationProductView do
  use ManateeWeb, :view
  alias ManateeWeb.ApplicationProductView

  def render("index.json", %{application_products: application_products}) do
    %{data: render_many(application_products, ApplicationProductView, "application_product.json")}
  end

  def render("show.json", %{application_product: application_product}) do
    %{data: render_one(application_product, ApplicationProductView, "application_product.json")}
  end

  def render("application_product.json", %{application_product: application_product}) do
    %{id: application_product.id,
      rate: application_product.rate,
      rate_unit: application_product.rate_unit,
      interval: application_product.interval,
      interval_unit: application_product.interval_unit}
  end
end
