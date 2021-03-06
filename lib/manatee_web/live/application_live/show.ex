defmodule ManateeWeb.ApplicationLive.Show do
  use ManateeWeb, :live_view

  alias Manatee.Applications
  alias Manatee.Products
  alias Manatee.Areas
  alias ManateeWeb.ApplicationLive.ApplicationProductLifeComponent

  @impl true
  def mount(_params, session, socket) do
    current_user = ManateeWeb.Live.AuthHelper.load_user!(session)
    socket = assign(socket, :current_user, current_user)

    products =
      Products.list_products() |> Enum.map(fn prod -> [key: prod.name, value: prod.id] end)

    products = Enum.concat([[key: "", value: ""]], products)
    {:ok, assign(socket, :products, products)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def apply_action(socket, :add_products, %{"id" => id}) do
    application = Applications.get_application!(id) |> Manatee.Repo.preload(:area)
    {:ok, gdds} = Applications.gdd_since_application(application)

    socket
    |> assign(:application, application)
  end

  def apply_action(socket, :show, %{"id" => id}) do
    current_user = socket.assigns.current_user

    areas =
      Areas.by_user_id(current_user.id)
      |> Enum.map(fn area -> [key: area.name, value: area.id] end)

    application = Applications.get_application!(id) |> Manatee.Repo.preload(:area)
    {:ok, gdds} = Applications.gdd_since_application(application)

    socket
    |> assign(:areas, areas)
    |> assign(:gdds, gdds)
    |> assign(:application, application)
    |> assign(:page_title, page_title(socket.assigns.live_action))
  end

  def apply_action(
        socket,
        :delete_product,
        %{"id" => id, "application_product_id" => application_product_id}
      ) do
    application = Applications.get_application!(id)
    application_product = Applications.get_application_product!(application_product_id)
    {:ok, _} = Applications.delete_application_product(application_product)

    socket
    |> put_flash(:info, "Product deleted from application")
    |> push_redirect(to: Routes.application_show_path(socket, :show, application))
  end

  def apply_action(
        socket,
        :edit_product,
        %{"id" => id, "application_product_id" => application_product_id} = params
      ) do
    application = Applications.get_application!(id) |> Manatee.Repo.preload(:area)
    application_product = Applications.get_application_product!(application_product_id)
    # {:ok, _} = Applications.delete_application_product(application_product)
    {:ok, gdds} = Applications.gdd_since_application(application)

    socket
    |> assign(:application_product, application_product)
    |> assign(:gdds, gdds)
    |> assign(:application, application)
    |> assign(:page_title, page_title(socket.assigns.live_action))
  end

  defp page_title(:show), do: "Show Application"
  defp page_title(:edit), do: "Edit Application"
  defp page_title(:add_products), do: "Add Products"
  defp page_title(:delete_product), do: "Delete Product"
  defp page_title(:edit_product), do: "Edit Product"
end
