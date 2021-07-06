defmodule ManateeWeb.ApplicationLive.AddProductsComponent do
  use ManateeWeb, :live_component

  alias Manatee.Applications
  alias Manatee.Applications.ApplicationProduct

  @impl true
  def update(
        %{application: application} = assigns,
        socket
      ) do
    changeset = Applications.change_application(application)

    interval_units =
      Ecto.Enum.values(ApplicationProduct, :interval_unit) |> Enum.map(&Atom.to_string/1)

    rate_units = Ecto.Enum.values(ApplicationProduct, :rate_unit) |> Enum.map(&Atom.to_string/1)

    application_product_changeset =
      Applications.change_application_product(%ApplicationProduct{application_id: application.id})

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign(:interval_units, interval_units)
     |> assign(:rate_units, rate_units)
     |> assign(:product, nil)
     |> assign(:application_product_changeset, application_product_changeset)}
  end

  @impl true
  def handle_event(
        "validate",
        %{"application_product" => application_product_params},
        socket
      ) do
    application_product_changeset =
      socket.assigns.application_product
      |> Applications.change_application_product(application_product_params)
      |> Map.put(:action, :validate)

    %{"product_id" => product_id} = application_product_params

    product =
      if socket.assigns.product != nil and socket.assigns.product.id == product_id do
        socket.assigns.product
      else
        Manatee.Products.get_product!(product_id)
      end

    {:noreply,
     assign(socket, :application_product_changeset, application_product_changeset)
     |> assign(:product, product)}
  end

  def handle_event("save", %{"application_product" => application_product_params}, socket) do
    save_application_product(socket, socket.assigns.action, application_product_params)
  end

  defp calculate_lbs_per_m(rate, analysis) do
    # take rate, by percentage analysis, by 1/100th for total lbs/M
    rate * analysis * 0.01
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div class="mt-10 sm:mt-0">
      <div class="md:grid md:grid-cols-3 md:gap-6">
        <div class="md:col-span-1">
          <div class="px-4 sm:px-0">
            <h3 class="text-lg font-medium leading-6 text-gray-900"><%= @title %></h3>
            <div class="text-md" id="application-<%= @id %>">
              Add Products to <%= @application.description %>
            </div>
          </div>
        </div>
        <div class="mt-5 md:mt-0 md:col-span-2">
          <%= f = form_for @application_product_changeset, "#",
            id: "application-form",
            phx_target: @myself,
            phx_change: "validate",
            phx_submit: "save" %>

          <div class="shadow overflow-hidden sm:rounded-md">
            <div class="px-4 py-5 bg-white sm:p-6">
              <div class="grid grid-cols-6 gap-6">

                <div class="col-span-3 sm:col-span-3">
                  <%= label f, :product, class: "block text-sm font-medium text-gray-700 block text-sm font-medium text-gray-700" %>
                  <%= select f, :product_id, @products, phx_target: @myself, class: "mt-1 focus:ring-indigo-500 focus:border-indigo-500 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md" %>
                  <%= error_tag f, :product %>
                </div>

                <%= if @product do %>
                  <div class="col-span-3 sm:col-span-3">
                    <div class="block text-sm font-medium text-gray-700 block text-sm font-medium text-gray-700">
                      <%= @product.name %>
                    </div>
                    <div class="block text-sm font-medium text-gray-700 block text-sm font-medium text-gray-700">
                      Suggested Rate: <%= @product.rate %> <%= @product.rate_unit %>
                    </div>
                    <div class="block text-sm font-medium text-gray-700 block text-sm font-medium text-gray-700">
                      <%= if @product.n_analysis do %>
                        N #/M: <%= number_input f, :n_lbs_per_m, step: "any", disabled: true, class: "mt-1 focus:ring-indigo-500 focus:border-indigo-500 block shadow-sm sm:text-sm border-gray-300 rounded-md" %>
                      <% end %>
                    </div>
                    <div class="block text-sm font-medium text-gray-700 block text-sm font-medium text-gray-700">
                      <%= if @product.p_analysis do %>
                        P #/M: <%= number_input f, :p_lbs_per_m, step: "any", disabled: true, class: "mt-1 focus:ring-indigo-500 focus:border-indigo-500 block shadow-sm sm:text-sm border-gray-300 rounded-md" %>
                      <% end %>
                    </div>
                    <div class="block text-sm font-medium text-gray-700 block text-sm font-medium text-gray-700">
                      <%= if @product.k_analysis do %>
                        K #/M: <%= number_input f, :k_lbs_per_m, step: "any", disabled: true, class: "mt-1 focus:ring-indigo-500 focus:border-indigo-500 block shadow-sm sm:text-sm border-gray-300 rounded-md" %>
                      <% end %>
                    </div>
                  </div>
                <% else %>
                  <div class="col-span-3 sm:col-span-3">
                  </div>
                <% end %>


                <%= if @product do %>
                  <div class="col-span-2 sm:col-span-3">
                    <%= label f, :rate,  class: "text-sm font-medium text-gray-700" %>
                    <%= number_input f, :rate, step: "any", class: "mt-1 focus:ring-indigo-500 focus:border-indigo-500 block shadow-sm sm:text-sm border-gray-300 rounded-md" %>
                    <%= error_tag f, :rate %>
                  </div>
                  <div class="col-span-2 sm:col-span-3">
                    <%= label f, :rate_unit,  class: "text-sm font-medium text-gray-700" %>
                    <%= select f, :rate_unit, @rate_units, value: @product.rate_unit, class: "mt-1 py-2 px-3 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"%>
                    <%= error_tag f, :rate_unit %>
                  </div>
                <% else %>
                  <div class="col-span-2 sm:col-span-3">
                    <%= label f, :rate,  class: "text-sm font-medium text-gray-700" %>
                    <%= number_input f, :rate, step: "any", class: "mt-1 focus:ring-indigo-500 focus:border-indigo-500 block shadow-sm sm:text-sm border-gray-300 rounded-md" %>
                    <%= error_tag f, :rate %>
                  </div>
                  <div class="col-span-2 sm:col-span-3">
                    <%= label f, :rate_unit,  class: "text-sm font-medium text-gray-700" %>
                    <%= select f, :rate_unit, @rate_units, class: "mt-1 py-2 px-3 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"%>
                    <%= error_tag f, :rate_unit %>
                  </div>
                <% end %>

                <div class="col-span-6 sm:col-span-2">
                  <%= label f, :interval,  class: "text-sm font-medium text-gray-700" %>
                  <%= number_input f, :interval, step: "any", class: "mt-1 focus:ring-indigo-500 focus:border-indigo-500 block shadow-sm sm:text-sm border-gray-300 rounded-md" %>
                  <%= error_tag f, :interval %>
                </div>

                <div class="col-span-6 sm:col-span-2">
                  <%= label f, :interval_unit,  class: "text-sm font-medium text-gray-700" %>
                  <%= select f, :interval_unit, @interval_units, class: "mt-1 py-2 px-3 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"%>
                  <%= error_tag f, :interval_unit %>
                </div>

                <%= hidden_input f, :application_id, value: @application.id %>

              </div>
            </div>

            <div class="px-4 py-3 text-right sm:px-6">
              <%= submit "Save", phx_disable_with: "Saving...", class: "inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500" %>
            </div>
          </div>
        </form>
        </div>
    </div>

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
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
