defmodule ManateeWeb.ApplicationLive.Index do
  use ManateeWeb, :live_view

  alias Manatee.Applications
  alias Manatee.Applications.Application

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :applications, list_applications())}
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

    {:noreply, assign(socket, :applications, list_applications())}
  end

  defp list_applications do
    Applications.list_applications()
  end
end
