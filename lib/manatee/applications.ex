defmodule Manatee.Applications do
  @moduledoc """
  The Applications context.
  """
  import Ecto.Query, only: [from: 2]
  import Ecto.Query, warn: false
  alias Manatee.Repo
  alias Manatee.GDDUtility

  alias Manatee.Applications.Application
  alias Manatee.Locations
  alias Manatee.Locations.Location
  alias Manatee.Locations.LocationWeather
  alias Manatee.Areas.Area
  alias Manatee.Accounts.User


  @doc """
  Returns the list of applications.

  ## Examples

      iex> list_applications()
      [%Application{}, ...]

  """
  def list_applications do
    Repo.all(Application)
  end

  def by_user_id(user_id) do
    location_ids = Locations.by_user_id(user_id) |> Enum.map(fn loc -> loc.id end)
    from(app in Application,
        join: area in Area,
        join: loc in Location,
        join: user in User,
        on:
          area.id == app.area_id and
            loc.id == area.location_id and
            loc.user_id == user.id,
        where:
          user.id == ^user_id
    )
    |> Repo.all()
  end

  @doc """
  Gets a single application.

  Raises `Ecto.NoResultsError` if the Application does not exist.

  ## Examples

      iex> get_application!(123)
      %Application{}

      iex> get_application!(456)
      ** (Ecto.NoResultsError)

  """
  def get_application!(id),
    do: Repo.get!(Application, id) |> Repo.preload(application_products: :product)

  @doc """
  Creates a application.

  ## Examples

      iex> create_application(%{field: value})
      {:ok, %Application{}}

      iex> create_application(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_application(attrs \\ %{}) do
    %Application{}
    |> Application.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a application.

  ## Examples

      iex> update_application(application, %{field: new_value})
      {:ok, %Application{}}

      iex> update_application(application, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_application(%Application{} = application, attrs) do
    application
    |> Application.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a application.

  ## Examples

      iex> delete_application(application)
      {:ok, %Application{}}

      iex> delete_application(application)
      {:error, %Ecto.Changeset{}}

  """
  def delete_application(%Application{} = application) do
    Repo.delete(application)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking application changes.

  ## Examples

      iex> change_application(application)
      %Ecto.Changeset{data: %Application{}}

  """
  def change_application(%Application{} = application, attrs \\ %{}) do
    application
    |> Repo.preload(:area, application_products: :product)
    |> Application.changeset(attrs)
  end

  def gdd_since_application(%Application{} = application) do
    weathers =
      from(app in Application,
        join: area in Area,
        join: loc in Location,
        join: lw in LocationWeather,
        on:
          area.id == app.area_id and
            loc.id == area.location_id and
            loc.id == lw.location_id,
        where:
          app.id == ^application.id and
            lw.day >= fragment("?", type(^application.applied_at, :date)),
        select: %{
          min_temp: lw.min_temp,
          max_temp: lw.max_temp,
          humidity: lw.humidity,
          desc: app.description,
          area_name: area.name
        }
      )
      |> Repo.all()

    gdd_0c =
      weathers
      |> Enum.map(fn weather ->
        GDDUtility.calc_gdd(weather.min_temp, weather.max_temp, 0)
      end)
      |> Enum.sum()
      |> :erlang.float()
      |> :erlang.float_to_binary(decimals: 1)

    gdd_10c =
      weathers
      |> Enum.map(fn weather ->
        GDDUtility.calc_gdd(weather.min_temp, weather.max_temp, 10)
      end)
      |> Enum.sum()
      |> :erlang.float()
      |> :erlang.float_to_binary(decimals: 1)

    {:ok, %{gdd_0c: gdd_0c, gdd_10c: gdd_10c}}
  end

  alias Manatee.Applications.ApplicationProduct

  @doc """
  Returns the list of application_products.

  ## Examples

      iex> list_application_products()
      [%ApplicationProduct{}, ...]

  """
  def list_application_products do
    Repo.all(ApplicationProduct)
  end

  @doc """
  Gets a single application_product.

  Raises `Ecto.NoResultsError` if the Application product does not exist.

  ## Examples

      iex> get_application_product!(123)
      %ApplicationProduct{}

      iex> get_application_product!(456)
      ** (Ecto.NoResultsError)

  """
  def get_application_product!(id), do: Repo.get!(ApplicationProduct, id)

  @doc """
  Creates a application_product.

  ## Examples

      iex> create_application_product(%{field: value})
      {:ok, %ApplicationProduct{}}

      iex> create_application_product(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_application_product(attrs \\ %{}) do
    %ApplicationProduct{}
    |> ApplicationProduct.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a application_product.

  ## Examples

      iex> update_application_product(application_product, %{field: new_value})
      {:ok, %ApplicationProduct{}}

      iex> update_application_product(application_product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_application_product(%ApplicationProduct{} = application_product, attrs) do
    application_product
    |> ApplicationProduct.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a application_product.

  ## Examples

      iex> delete_application_product(application_product)
      {:ok, %ApplicationProduct{}}

      iex> delete_application_product(application_product)
      {:error, %Ecto.Changeset{}}

  """
  def delete_application_product(%ApplicationProduct{} = application_product) do
    Repo.delete(application_product)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking application_product changes.

  ## Examples

      iex> change_application_product(application_product)
      %Ecto.Changeset{data: %ApplicationProduct{}}

  """
  def change_application_product(%ApplicationProduct{} = application_product, attrs \\ %{}) do
    ApplicationProduct.changeset(application_product, attrs)
  end
end
