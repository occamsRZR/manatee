defmodule Manatee.HargreavesEquation do
  def calculate_eto(%Manatee.Locations.Location{} = location, min_temp, max_temp, date) do
    avg_temp = (min_temp + max_temp) / 2
    lat_rad = deg_to_rad(location.lat)
    day_of_year = date |> Timex.day()
    sol_dec = solar_declination(day_of_year)
    sha = sunset_hour_angle(lat_rad, sol_dec)
    ird = inv_rel_dist_earth_sun(day_of_year)
    et_rad = et_rad(lat_rad, sol_dec, sha, ird)
    calculate_eto(min_temp, max_temp, avg_temp, et_rad)
  end

  @doc """
  Estimate reference evapotranspiration over grass (ETo) using the Hargreaves
  equation.
  Generally, when solar radiation data, relative humidity data
  and/or wind speed data are missing, it is better to estimate them using
  the functions available in this module, and then calculate ETo
  the FAO Penman-Monteith equation. However, as an alternative, ETo can be
  estimated using the Hargreaves ETo equation.
  Based on equation 52 in Allen et al (1998).
  :param tmin: Minimum daily temperature [deg C]
  :param tmax: Maximum daily temperature [deg C]
  :param tmean: Mean daily temperature [deg C]. If emasurements not
      available it can be estimated as (*tmin* + *tmax*) / 2.
  :param et_rad: Extraterrestrial radiation (Ra) [MJ m-2 day-1]. Can be
      estimated using ``et_rad()``.
  :return: Reference evapotranspiration over grass (ETo) [mm day-1]
  :rtype: float
  # Note, multiplied by 0.408 to convert extraterrestrial radiation could
  # be given in MJ m-2 day-1 rather than as equivalent evaporation in
  # mm day-1
   return 0.0023 * (tmean + 17.8) * (tmax - tmin) ** 0.5 * 0.408 * et_rad
  """
  def calculate_eto(min_temp, max_temp, avg_temp, et_rad) do
    # :math.pow(0.0023 * (avg_temp + 17.8) * (max_temp - min_temp), 0.5 * 0.408 * et_rad)
    0.0023 * (avg_temp + 17.8) * :math.pow(max_temp - min_temp, 0.5) * 0.408 * et_rad
  end

  @doc """
  Convert angular degrees to radians
  :param degrees: Value in degrees to be converted.
  :return: Value in radians
  :rtype: float
  """
  def deg_to_rad(degrees) do
    degrees * (:math.pi() / 180.0)
  end

  @doc """
    def sol_dec(day_of_year):
    Calculate solar declination from day of the year.
    Based on FAO equation 24 in Allen et al (1998).
    :param day_of_year: Day of year integer between 1 and 365 or 366).
    :return: solar declination [radians]
    :rtype: floatKKK
    _check_doy(day_of_year)
    return 0.409 * math.sin(((2.0 * math.pi / 365.0) * day_of_year - 1.39))
  """
  def solar_declination(day_of_year) do
    0.409 * :math.sin(2.0 * :math.pi() / 365.0 * day_of_year - 1.39)
  end

  @doc """
    cos_sha = -math.tan(latitude) * math.tan(sol_dec)
    # See http://www.itacanet.org/the-sun-as-a-source-of-energy/
    # part-3-calculating-solar-angles/
    # Domain of acos is -1 <= x <= 1 radians (this is not mentioned in FAO-56!)
    return math.acos(min(max(cos_sha, -1.0), 1.0))
  """
  def sunset_hour_angle(lat_rad, sol_dec) do
    cos_sha = -:math.tan(lat_rad) * :math.tan(sol_dec)
    :math.acos(cos_sha)
  end

  def inv_rel_dist_earth_sun(day_of_year) do
    1 + 0.033 * :math.cos(2.0 * :math.pi() / 365.0 * day_of_year)
  end

  def et_rad(lat_rad, sol_dec, sha, ird) do
    solar_constant = 0.0820

    tmp1 = 24.0 * 60.0 / :math.pi()
    tmp2 = sha * :math.sin(lat_rad) * :math.sin(sol_dec)
    tmp3 = :math.cos(lat_rad) * :math.cos(sol_dec) * :math.sin(sha)
    tmp1 * solar_constant * ird * (tmp2 + tmp3)
  end
end
