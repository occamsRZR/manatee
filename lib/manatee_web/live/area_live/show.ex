defmodule ManateeWeb.AreaLive.Show do
  use ManateeWeb, :live_view

  alias Manatee.Areas

  @impl true
  def mount(_params, session, socket) do
    current_user = ManateeWeb.Live.AuthHelper.load_user!(session)
    areas = Areas.by_user_id(current_user.id) |> Enum.map(fn area -> [key: area.name, value: area.id] end)

    {:ok,
     assign(socket, :current_user, current_user)
     |> assign(:areas, areas)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:area, Areas.get_area!(id))}
  end

  defp page_title(:show), do: "Show Area"
  defp page_title(:edit), do: "Edit Area"
end
