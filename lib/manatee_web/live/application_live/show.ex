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
  def handle_params(%{"id" => id}, _, socket) do
    current_user = socket.assigns.current_user

    areas =
      Areas.by_user_id(current_user.id)
      |> Enum.map(fn area -> [key: area.name, value: area.id] end)

    application = Applications.get_application!(id) |> Manatee.Repo.preload(:area)
    {:ok, gdds} = Applications.gdd_since_application(application)

    {:noreply,
     socket
     |> assign(:areas, areas)
     |> assign(:gdds, gdds)
     |> assign(:application, application)
     |> assign(:page_title, page_title(socket.assigns.live_action))}
  end

  defp page_title(:show), do: "Show Application"
  defp page_title(:edit), do: "Edit Application"
  defp page_title(:add_products), do: "Add Products"
end
