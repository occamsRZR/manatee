defmodule Manatee.Areas do
  import Ecto.Query, only: [from: 2]

  @moduledoc """
  The Areas context.
  """

  import Ecto.Query, warn: false
  alias Manatee.Repo

  alias Manatee.Areas.Area
  alias Manatee.Locations

  alias Manatee.Applications.Application
  alias Manatee.Applications.ApplicationProduct

  @doc """
  Returns the list of areas.

  ## Examples

      iex> list_areas()
      [%Area{}, ...]

  """
  def list_areas do
    Repo.all(Area)
  end

  def by_user_id(user_id) do
    location_ids = Locations.by_user_id(user_id) |> Enum.map(fn loc -> loc.id end)

    from(
      a in Area,
      where: a.location_id in ^location_ids
    )
    |> Repo.all()
  end

  @doc """
  Gets a single area.

  Raises `Ecto.NoResultsError` if the Area does not exist.

  ## Examples

      iex> get_area!(123)
      %Area{}

      iex> get_area!(456)
      ** (Ecto.NoResultsError)

  """
  def get_area!(id), do: Repo.get!(Area, id)

  def get_area_nutrient_totals(area_id) do
    from(
      app_pro in ApplicationProduct,
      join: app in Application,
      on: app_pro.application_id == app.id,
      where: app.area_id == ^area_id,
      select: %{
        applied_at: app.applied_at,
        description: app.description,
        total_n: sum(app_pro.n_lbs_per_m),
        total_p: sum(app_pro.p_lbs_per_m),
        total_k: sum(app_pro.k_lbs_per_m)
      },
      group_by: [app.description, app.id],
      order_by: app.applied_at
    )
    |> Repo.all()
  end

  @doc """
  Creates a area.

  ## Examples

      iex> create_area(%{field: value})
      {:ok, %Area{}}

      iex> create_area(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_area(attrs \\ %{}) do
    %Area{}
    |> Area.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a area.

  ## Examples

      iex> update_area(area, %{field: new_value})
      {:ok, %Area{}}

      iex> update_area(area, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_area(%Area{} = area, attrs) do
    area
    |> Area.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a area.

  ## Examples

      iex> delete_area(area)
      {:ok, %Area{}}

      iex> delete_area(area)
      {:error, %Ecto.Changeset{}}

  """
  def delete_area(%Area{} = area) do
    Repo.delete(area)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking area changes.

  ## Examples

      iex> change_area(area)
      %Ecto.Changeset{data: %Area{}}

  """
  def change_area(%Area{} = area, attrs \\ %{}) do
    Area.changeset(area, attrs)
  end
end
