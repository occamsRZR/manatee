defmodule ManateeWeb.AreaLive.Index do
  use ManateeWeb, :live_view

  alias Manatee.Accounts
  alias Manatee.Areas
  alias Manatee.Areas.Area

  @impl true
  def mount(_params, %{"user_id" => user_id} = _session, socket) do
    socket = assign(socket, current_user: Accounts.get_user!(user_id))

    {:ok, socket}
  end

  @impl true
  def mount(_params, session, socket) do
    socket =
      socket
      |> assign_new(:current_user, fn ->
        ManateeWeb.Live.AuthHelper.load_user!(session)
      end)

    socket = assign_new(socket, :areas, fn -> list_areas(socket.assigns.current_user.id) end)

    {:ok, socket}
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

    {:noreply, assign(socket, :areas, list_areas(0))}
  end

  defp list_areas(user_id) do
    Areas.by_user_id(user_id) |> Manatee.Repo.preload(:location)
  end
end
