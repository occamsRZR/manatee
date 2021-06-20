defmodule ManateeWeb.ApplicationLive.AddProductsComponent do
  use ManateeWeb, :live_component
  require IEx

  alias Manatee.Applications
  alias Manatee.Applications.ApplicationProduct

  @impl true
  def update(
        %{application: application} = assigns,
        socket
      ) do
    changeset = Applications.change_application(application)
    IO.inspect(assigns)

    application_product_changeset =
      Applications.change_application_product(%ApplicationProduct{application_id: application.id})

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign(:application_product_changeset, application_product_changeset)}
  end

  @impl true
  def handle_event("validate", %{"application_product" => application_product_params}, socket) do
    application_product_changeset =
      socket.assigns.application_product
      |> Applications.change_application_product(application_product_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :application_product_changeset, application_product_changeset)}
  end

  def handle_event("save", %{"application_product" => application_product_params}, socket) do
    save_application_product(socket, socket.assigns.action, application_product_params)
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div id="application-<%= @id %>">
      <%= @application.description %>
    </div>
    <%= f = form_for @application_product_changeset, "#",
    id: "application-form",
    phx_target: @myself,
    phx_change: "validate",
    phx_submit: "save" %>


    <%= label f, :rate %>
    <%= text_input f, :rate %>
    <%= error_tag f, :rate %>

    <%= label f, :rate_unit %>
    <%= text_input f, :rate_unit %>
    <%= error_tag f, :rate_unit %>

    <%= label f, :interval %>
    <%= number_input f, :interval %>
    <%= error_tag f, :interval %>

    <%= label f, :interval_unit %>
    <%= text_input f, :interval_unit %>
    <%= error_tag f, :interval_unit %>

    <%= hidden_input f, :application_id, value: @application.id %>

    <%= submit "Save", phx_disable_with: "Saving..." %>
    </form>

    """
  end

  defp save_application_product(socket, :add_products, application_params) do
    case Applications.create_application_product(application_params) do
      {:ok, _application} ->
        {:noreply,
         socket
         |> put_flash(:info, "Application Product updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        IEx.pry()
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
