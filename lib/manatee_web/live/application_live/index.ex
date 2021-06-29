defmodule ManateeWeb.ApplicationLive.Index do
  use ManateeWeb, :live_view

  alias Manatee.Areas
  alias Manatee.Applications
  alias Manatee.Applications.Application
  alias Manatee.Applications.ApplicationProduct
  alias Manatee.Products

  @impl true
  def mount(_params, session, socket) do
    current_user = ManateeWeb.Live.AuthHelper.load_user!(session)
    areas = Areas.by_user_id(current_user.id) |> Enum.map(fn area -> [key: area.name, value: area.id] end)
    {:ok,
     assign(socket, :applications, list_applications(current_user.id))
     |> assign(:areas, areas)
     |> assign(
       :products,
       Products.list_products() |> Enum.map(fn prod -> [key: prod.name, value: prod.id] end)
     )}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Application")
    |> assign(:application, Applications.get_application!(id))
  end

  defp apply_action(socket, :add_products, %{"id" => id}) do
    socket
    |> assign(:page_title, "Application Products")
    |> assign(:application, Applications.get_application!(id))
    |> assign(:application_product, %ApplicationProduct{application_id: id})
    |> assign(
      :products,
      Products.list_products() |> Enum.map(fn prod -> [key: prod.name, value: prod.id] end)
    )
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Application")
    |> assign(:application, %Application{application_products: []})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Applications")
    |> assign(:application, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    application = Applications.get_application!(id)
    {:ok, _} = Applications.delete_application(application)

    {:noreply, assign(socket, :applications, list_applications(socket.assigns.current_user.id))}
  end

  defp list_applications(user_id) do
    Applications.by_user_id(user_id) |> Manatee.Repo.preload(:area)
  end
end
