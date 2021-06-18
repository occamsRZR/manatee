defmodule ManateeWeb.AreaLive.FormComponent do
  use ManateeWeb, :live_component

  alias Manatee.Areass

  @impl true
  def update(%{area: area} = assigns, socket) do
    changeset = Areass.change_area(area)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"area" => area_params}, socket) do
    changeset =
      socket.assigns.area
      |> Areass.change_area(area_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"area" => area_params}, socket) do
    save_area(socket, socket.assigns.action, area_params)
  end

  defp save_area(socket, :edit, area_params) do
    case Areass.update_area(socket.assigns.area, area_params) do
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
    case Areass.create_area(area_params) do
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
