defmodule ManateeWeb.AreaLive.FormComponent do
  use ManateeWeb, :live_component

  alias Manatee.Areas
  alias Manatee.Areas.Area
  alias Manatee.Locations

  @impl true
  def update(%{area: area, user_id: user_id} = assigns, socket) do
    changeset = Areas.change_area(area)

    locations =
      Locations.by_user_id(user_id)
      |> Enum.map(fn loc -> [key: loc.name, value: loc.id] end)

    grass_types = Ecto.Enum.values(Area, :grass_type) |> Enum.map(&Atom.to_string/1)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign(:grass_types, grass_types)
     |> assign(:locations, locations)}
  end

  @impl true
  def handle_event("validate", %{"area" => area_params}, socket) do
    changeset =
      socket.assigns.area
      |> Areas.change_area(area_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"area" => area_params}, socket) do
    save_area(socket, socket.assigns.action, area_params)
  end

  defp save_area(socket, :edit, area_params) do
    case Areas.update_area(socket.assigns.area, area_params) do
      {:ok, _area} ->
        {:noreply,
         socket
         |> put_flash(:info, "Area updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_area(socket, :new, area_params) do
    case Areas.create_area(area_params) do
      {:ok, _area} ->
        {:noreply,
         socket
         |> put_flash(:info, "Area created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
