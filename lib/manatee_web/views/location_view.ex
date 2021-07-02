defmodule ManateeWeb.LocationView do
  use ManateeWeb, :view

  alias Manatee.GDDUtility

  # (0°C × 9/5) + 32 = 32°F
  def c_to_f(temp) do
    temp * 9 / 5 + 32
  end

  def format_temp(temp) do
    :erlang.float_to_binary(temp, decimals: 1)
  end

  def gdd(min_temp, max_temp, base) do
    GDDUtility.calc_gdd(min_temp, max_temp, base)
  end

  def eto_inches(%Manatee.Locations.Location{} = location, min_temp, max_temp, date, crop_coef) do
    Manatee.HargreavesEquation.calculate_eto(location, min_temp, max_temp, date) / 25.4 *
      crop_coef
  end
end
