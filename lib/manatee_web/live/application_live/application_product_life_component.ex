defmodule ManateeWeb.ApplicationLive.ApplicationProductLifeComponent do
  use Phoenix.LiveComponent

  def calculate_lifespan_percentage(%{gdd: gdd, gdd_interval: gdd_interval}) do
    {gdd, _} = gdd |> Float.parse
    gdd = gdd * 100.0
    gdd / gdd_interval |> :erlang.float_to_binary(decimals: 1)
  end

  def calculate_lifespan_percentage(_) do
    5
  end

  def render(assigns) do
    ~L"""

    <!-- Define the width model within parent div -->
    <div
        class="my-10"
        x-data="{ width: '<%= calculate_lifespan_percentage(%{gdd: @gdds.gdd_0c, gdd_interval: @application_product.interval}) %>' }"
        x-init="$watch('width', value => { if (value > 100) { width = 100 } if (value == 0) { width = 10 } })"
        >
        <div class="p-6 mx-8 my-4 max-w-full bg-gray-100 shadow rounded">
            <!-- Start Regular with text version -->
            <%= @application_product.product.name %>

            <div> <%= @gdds.gdd_0c %> / <%= @application_product.interval %> <%= @application_product.product.interval_unit %> </div>

            <div 
                class="bg-gray-600 rounded h-6 mt-5" 
                role="progressbar" 
                :aria-valuenow="width"
                aria-valuemin="0"
                aria-valuemax="100"
                >

    
                <div 
                    class="bg-green-600 rounded h-6 text-center text-white text-sm transition"
                    :style="`width: ${width}%; transition: width 2s;`" 
                    x-text="`${width}%`"
                    >
                </div>
            </div>
            <!-- End Regular with text version -->
        </div>
    </div>
    """
  end
end
