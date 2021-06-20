defmodule ManateeWeb.AreaLive.Index do
  use ManateeWeb, :live_view

  alias Manatee.Areas
  alias Manatee.Areas.Area

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :areas, list_areas())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Area")
    |> assign(:area, Areas.get_area!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Area")
    |> assign(:area, %Area{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Areas")
    |> assign(:area, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    area = Areas.get_area!(id)
    {:ok, _} = Areas.delete_area(area)

    {:noreply, assign(socket, :areas, list_areas())}
  end

  defp list_areas do
    Areas.list_areas()
  end
end
