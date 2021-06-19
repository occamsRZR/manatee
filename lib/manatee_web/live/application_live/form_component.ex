defmodule ManateeWeb.ApplicationLive.FormComponent do
  use ManateeWeb, :live_component

  alias Manatee.Applications
  alias Manatee.Applications.ApplicationProduct

  @impl true
  def update(%{application: application} = assigns, socket) do
    changeset = Applications.change_application(application)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"application" => application_params}, socket) do
    changeset =
      socket.assigns.application
      |> Applications.change_application(application_params)
      |> Ecto.Changeset.put_assoc(
        :application_products,
        application_params[:application_products]
      )
      |> Map.put(:action, :validate)

    require IEx
    IEx.pry()
    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"application" => application_params}, socket) do
    save_application(socket, socket.assigns.action, application_params)
  end

  def handle_event("add-product", _, socket) do
    existing_application_products =
      Map.get(
        socket.assigns.application,
        :application_products,
        []
      )

    application_products =
      existing_application_products
      |> Enum.concat([
        # # NOTE temp_id
        Applications.change_application_product(%ApplicationProduct{temp_id: get_temp_id()})
      ])

    changeset =
      Applications.change_application(socket.assigns.application)
      |> Ecto.Changeset.put_assoc(:application_products, application_products)

    {:noreply, assign(socket, changeset: changeset, application_products: application_products)}
  end

  defp save_application(socket, :edit, application_params) do
    case Applications.update_application(socket.assigns.application, application_params) do
      {:ok, _application} ->
        {:noreply,
         socket
         |> put_flash(:info, "Application updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_application(socket, :new, application_params) do
    case Applications.create_application(application_params) do
      {:ok, _application} ->
        {:noreply,
         socket
         |> put_flash(:info, "Application created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  # JUST TO GENERATE A RANDOM STRING
  defp get_temp_id, do: :crypto.strong_rand_bytes(5) |> Base.url_encode64() |> binary_part(0, 5)
end
