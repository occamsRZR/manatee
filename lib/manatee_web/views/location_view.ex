defmodule ManateeWeb.LocationView do
  use ManateeWeb, :view

  # (0°C × 9/5) + 32 = 32°F
  def c_to_f(temp) do
    temp * 9 / 5 + 32
  end

  def format_temp(temp) do
    :erlang.float_to_binary(temp, decimals: 1)
  end

  def gdd(min_temp, max_temp, base) do
    (max_temp + min_temp) / 2 - base
  end
end
