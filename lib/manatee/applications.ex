defmodule Manatee.Applications do
  @moduledoc """
  The Applications context.
  """

  import Ecto.Query, warn: false
  alias Manatee.Repo

  alias Manatee.Applications.Application

  @doc """
  Returns the list of applications.

  ## Examples

      iex> list_applications()
      [%Application{}, ...]

  """
  def list_applications do
    Repo.all(Application)
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
    |> Repo.preload(application_products: :product)
    |> Application.changeset(attrs)
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
