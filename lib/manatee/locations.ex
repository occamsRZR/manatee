defmodule Manatee.Locations do
  @moduledoc """
  The Locations context.
  """

  import Ecto.Query, warn: false
  alias Manatee.Repo

  alias Manatee.Locations.Location

  @doc """
  Returns the list of locations.

  ## Examples

      iex> list_locations()
      [%Location{}, ...]

  """
  def list_locations do
    Repo.all(Location)
  end

  @doc """
  Gets a single location.

  Raises `Ecto.NoResultsError` if the Location does not exist.

  ## Examples

      iex> get_location!(123)
      %Location{}

      iex> get_location!(456)
      ** (Ecto.NoResultsError)

  """
  def get_location!(id), do: Repo.get!(Location, id) |> Repo.preload(:weathers)

  @doc """
  Creates a location.

  ## Examples

      iex> create_location(%{field: value})
      {:ok, %Location{}}

      iex> create_location(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_location(attrs \\ %{}) do
    %Location{}
    |> Location.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a location.

  ## Examples

      iex> update_location(location, %{field: new_value})
      {:ok, %Location{}}

      iex> update_location(location, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_location(%Location{} = location, attrs) do
    location
    |> Location.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a location.

  ## Examples

      iex> delete_location(location)
      {:ok, %Location{}}

      iex> delete_location(location)
      {:error, %Ecto.Changeset{}}

  """
  def delete_location(%Location{} = location) do
    Repo.delete(location)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking location changes.

  ## Examples

      iex> change_location(location)
      %Ecto.Changeset{data: %Location{}}

  """
  def change_location(%Location{} = location, attrs \\ %{}) do
    Location.changeset(location, attrs)
  end

  alias Manatee.Locations.LocationWeather

  @doc """
  Returns the list of location_weathers.

  ## Examples

      iex> list_location_weathers()
      [%LocationWeather{}, ...]

  """
  def list_location_weathers do
    Repo.all(LocationWeather)
  end

  @doc """
  Gets a single location_weather.

  Raises `Ecto.NoResultsError` if the Location weather does not exist.

  ## Examples

      iex> get_location_weather!(123)
      %LocationWeather{}

      iex> get_location_weather!(456)
      ** (Ecto.NoResultsError)

  """
  def get_location_weather!(id), do: Repo.get!(LocationWeather, id)

  @doc """
  Creates a location_weather.

  ## Examples

      iex> create_location_weather(%{field: value})
      {:ok, %LocationWeather{}}

      iex> create_location_weather(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_location_weather(attrs \\ %{}) do
    %LocationWeather{}
    |> LocationWeather.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a location_weather.

  ## Examples

      iex> update_location_weather(location_weather, %{field: new_value})
      {:ok, %LocationWeather{}}

      iex> update_location_weather(location_weather, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_location_weather(%LocationWeather{} = location_weather, attrs) do
    location_weather
    |> LocationWeather.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a location_weather.

  ## Examples

      iex> delete_location_weather(location_weather)
      {:ok, %LocationWeather{}}

      iex> delete_location_weather(location_weather)
      {:error, %Ecto.Changeset{}}

  """
  def delete_location_weather(%LocationWeather{} = location_weather) do
    Repo.delete(location_weather)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking location_weather changes.

  ## Examples

      iex> change_location_weather(location_weather)
      %Ecto.Changeset{data: %LocationWeather{}}

  """
  def change_location_weather(%LocationWeather{} = location_weather, attrs \\ %{}) do
    LocationWeather.changeset(location_weather, attrs)
  end
end
