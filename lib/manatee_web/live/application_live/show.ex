defmodule ManateeWeb.ApplicationLive.Show do
  use ManateeWeb, :live_view

  alias Manatee.Applications

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:application, Applications.get_application!(id))}
  end

  defp page_title(:show), do: "Show Application"
  defp page_title(:edit), do: "Edit Application"
  defp page_title(:add_products), do: "Add Products"
end
