defmodule Manatee.HargreavesEquation do
  def test_calculate_eto() do
    location = Manatee.Locations.get_location!("3e5fa07e-822a-442f-87d0-4be826c8885a")
    lat_rad = deg_to_rad(location.lat)
    day_of_year = Timex.now() |> Timex.day()
    sol_dec = solar_declination(day_of_year)
    sha = sunset_hour_angle(lat_rad, sol_dec)
    ird = inv_rel_dist_earth_sun(day_of_year)
    et_rad = et_rad(lat_rad, sol_dec, sha, ird)
    calculate_eto(18.61, 30.04, 24.33, et_rad)
  end

  def calculate_eto(min_temp, max_temp, avg_temp, et_rad) do
    :math.pow(0.0023 * (avg_temp + 17.8) * (max_temp - min_temp), 0.5 * 0.408 * et_rad)
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
