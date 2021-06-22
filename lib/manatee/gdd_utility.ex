defmodule Manatee.GDDUtility do
  def calc_gdd(min_temp, max_temp, base) do
    (max_temp + min_temp) / 2 - base
  end
end
