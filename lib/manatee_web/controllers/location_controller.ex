defmodule ManateeWeb.LocationController do
  use ManateeWeb, :controller

  alias Manatee.Locations
  alias Manatee.Locations.Location
  alias Manatee.Accounts.User

  def index(conn, _params) do
    case conn.assigns.current_user do
      %User{} = current_user ->
        locations = Locations.by_user_id(current_user.id)
        render(conn, "index.html", locations: locations)

      nil ->
        locations = []
        render(conn, "index.html", locations: locations)
    end
  end

  def new(conn, _params) do
    changeset = Locations.change_location(%Location{address: "", state: "", city: "", zip: ""})
    render(conn, "new.html", changeset: changeset, current_user: conn.assigns.current_user)
  end

  def create(conn, %{"location" => location_params}) do
    case Locations.create_location(location_params) do
      {:ok, location} ->
        conn
        |> put_flash(:info, "Location created successfully.")
        |> redirect(to: Routes.location_path(conn, :show, location))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    location = Locations.get_location!(id)
    render(conn, "show.html", location: location)
  end

  def edit(conn, %{"id" => id}) do
    location = Locations.get_location!(id)
    changeset = Locations.change_location(location)
    render(conn, "edit.html", location: location, changeset: changeset)
  end

  def update(conn, %{"id" => id, "location" => location_params}) do
    location = Locations.get_location!(id)

    case Locations.update_location(location, location_params) do
      {:ok, location} ->
        conn
        |> put_flash(:info, "Location updated successfully.")
        |> redirect(to: Routes.location_path(conn, :show, location))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", location: location, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    location = Locations.get_location!(id)
    {:ok, _location} = Locations.delete_location(location)

    conn
    |> put_flash(:info, "Location deleted successfully.")
    |> redirect(to: Routes.location_path(conn, :index))
  end
end
