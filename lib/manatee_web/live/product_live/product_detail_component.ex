defmodule ManateeWeb.ProductLive.ProductDetailComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""

    <div class="bg-white shadow overflow-hidden sm:rounded-lg">
      <div class="px-4 py-5 sm:px-6">
        <h3 class="text-lg leading-6 font-medium text-gray-900">Product Information</h3>
      </div>
      <div class="border-t border-gray-200">
        <dl>
          <div class="bg-white px-4 py-5 sm:grid sm:grid-cols-2 sm:gap-4 sm:px-6 md:grid md:grid-cols-2 hover:bg-gray-50 md:space-y-0 space-y-1 p-4 border-b">
            <dt class="text-sm font-medium text-gray-500">
              Name
            </dt>
            <dd class="mt-1 text-sm text-gray-900 sm:mt-0">
              <%= @product.name %>
            </dd>
          </div>
          <div class="bg-white px-4 py-5 sm:grid sm:grid-cols-2 sm:gap-4 sm:px-6 md:grid md:grid-cols-2 hover:bg-gray-50 md:space-y-0 space-y-1 p-4 border-b">
            <dt class="text-sm font-medium text-gray-500">
              Ingredients
            </dt>
            <dd class="mt-1 text-sm text-gray-900 sm:mt-0">
            <%= @product.ingredients %>
            </dd>
          </div>
          <div class="bg-gray-50 px-4 py-5 sm:grid sm:grid-cols-2 sm:gap-4 sm:px-6 md:grid md:grid-cols-2 hover:bg-gray-50 md:space-y-0 space-y-1 p-4 border-b">
            <dt class="text-sm font-medium text-gray-500">
              Suggested Rate
            </dt>
            <dd class="mt-1 text-sm text-gray-900 sm:mt-0">
              <%= @product.rate %> <%= @product.rate_unit %>
            </dd>
          </div>
          <div class="bg-white px-4 py-5 sm:grid sm:grid-cols-2 sm:gap-4 sm:px-6 md:grid md:grid-cols-2 hover:bg-gray-50 md:space-y-0 space-y-1 p-4 border-b">
            <dt class="text-sm font-medium text-gray-500">
            Suggested Interval
            </dt>
            <dd class="mt-1 text-sm text-gray-900 sm:mt-0">
            <%= @product.interval %> <%= @product.interval_unit %>
            </dd>
          </div>
          <div class="bg-gray-50 px-4 py-5 sm:grid sm:grid-cols-2 sm:gap-4 sm:px-6 md:grid md:grid-cols-2 hover:bg-gray-50 md:space-y-0 space-y-1 p-4 border-b">
            <dt class="text-sm font-medium text-gray-500">
            Nutrient Analysis
            </dt>
            <dd class="mt-1 text-sm text-gray-900 sm:mt-0">
            <%= if @product.n_analysis do %>
            <%= @product.n_analysis %>-<%= @product.p_analysis %>-<%= @product.k_analysis %>
            <% end %>      </dd>
          </div>
        </dl>
      </div>
    </div>
    """
  end
end
