defmodule ManateeWeb.ApplicationLive.ApplicationProductLifeComponent do
  use Phoenix.LiveComponent

  def calculate_lifespan_percentage(%{gdd: gdd, gdd_interval: gdd_interval}) do
    gdd / gdd_interval
  end

  def calculate_lifespan_percentage(_) do
    100
  end

  def render(assigns) do
    ~L"""

    """
  end
end
