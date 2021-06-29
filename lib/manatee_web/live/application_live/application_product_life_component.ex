defmodule ManateeWeb.ApplicationLive.ApplicationProductLifeComponent do
  use Phoenix.LiveComponent

  def calculate_lifespan_percentage(%{gdd: gdd, interval: gdd_interval, interval_unit: :gdd}) do
    {gdd, _} = gdd |> Float.parse()
    gdd = gdd * 100.0
    (gdd / gdd_interval) |> :erlang.float_to_binary(decimals: 1)
  end

  def calculate_lifespan_percentage(%{
        applied_at: applied_at,
        interval_unit: :day,
        interval: day_interval
      }) do
    (days_since_application(applied_at) / day_interval * 100.0)
    |> :erlang.float_to_binary(decimals: 1)
  end

  def calculate_lifespan_percentage(_) do
    5
  end

  def days_since_application(date) do
    Timex.diff(Timex.today(), date, :days)
  end

  def render_lifespan_text(assigns, %{interval_unit: :gdd}) do
    ~L"""
    <div> <%= @gdds.gdd_0c %> / <%= @application_product.interval %> <%= @application_product.product.interval_unit %> </div>
    """
  end

  def render_lifespan_text(assigns, %{interval_unit: :day}) do
    ~L"""
    <div> <%= days_since_application(@application.applied_at) %> / <%=  @application_product.interval %> days </div>
    """
  end

  def render_lifespan_text(_, _), do: nil

  def render(assigns) do
    ~L"""

    <!-- Define the width model within parent div -->
    <div
        class="my-10"
        x-data="{ width: '<%= calculate_lifespan_percentage(
          %{
            gdd: @gdds.gdd_0c,
            interval: @application_product.interval,
            interval_unit: @application_product.product.interval_unit,
            applied_at: @application.applied_at
          })
        %>' }"
        x-init="$watch('width', value => { if (value > 100) { width = 100 } if (value == 0) { width = 10 } })"
        >
        <div class="p-6 mx-8 my-4 max-w-full bg-gray-100 shadow rounded">
            <!-- Start Regular with text version -->
            <%= @application_product.product.name %>

            <%= render_lifespan_text(
              assigns,
              %{
                  gdd_0c: @gdds.gdd_0c,
                  gdd_10c: @gdds.gdd_10c,
                  interval_unit: @application_product.product.interval_unit,
                  inverval: @application_product.interval
              }) %>

            <div
                class="bg-gray-600 rounded h-6 mt-5"
                role="progressbar"
                :aria-valuenow="width"
                aria-valuemin="0"
                aria-valuemax="100"
                >


                <div
                    class="bg-green-600 rounded h-6 text-center text-white text-sm transition"
                    :style="`width: ${width}%; max-width: 100%`"
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
