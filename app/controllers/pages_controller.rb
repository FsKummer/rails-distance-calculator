class PagesController < ApplicationController
  def home; end

  def calculated
    point_a = latlong(params[:pointa])
    point_b = latlong(params[:pointb])
    @great_circle = calculate_gc(point_a, point_b)
    @rhumb_dist = calculate_rhumb(point_a, point_b)
  end

  def distance; end

  private

  def latlong(address)
    Geocoder.search(address).first.coordinates
  end

  def calculate_gc(a, b)
    radius = 6371
    d_lat = (b[0] - a[0]) * (Math::PI / 180)
    d_long = (b[1] - a[1]) * (Math::PI / 180)
    first = Math.sin(d_lat / 2) * Math.sin(d_lat / 2) +
            Math.cos((a[0]) * (Math::PI / 180)) *
            Math.cos((b[0]) * (Math::PI / 180)) *
            Math.sin(d_long / 2) * Math.sin(d_long / 2)
    second = 2 * Math.atan2(Math.sqrt(first), Math.sqrt(1 - first))
    radius * second # Distance in km
  end

  def calculate_rhumb(point_a, point_b)
    radius = 6371e3; # metres
    lat_a = point_a[0] * Math::PI / 180
    lat_b = point_b[0] * Math::PI / 180
    d_lat = (point_b[0] - point_a[0]) * Math::PI / 180
    d_long = longitude_diff(point_a[1], point_b[1]) * Math::PI / 180
    dep = Math.log(Math.tan(Math::PI / 4 + lat_b / 2) / Math.tan(Math::PI / 4 + lat_a / 2))
    q = dep.abs > 10e-12 ? d_lat/dep : Math.cos(lat_a) # E-W course becomes ill-conditioned with 0/0

    Math.sqrt(d_lat * d_lat + q * q * d_long * d_long) * radius / 1000 # distance in kilometers
  end

  def mean_latitude(lat_a, lat_b)
    sign_check = (lat_a.positive? && lat_b.positive?) || ((lat_a.negative? && lat_b.negative?))
    if sign_check
      lat_a.positive? ? (lat_a + lat_b) / 2 : -(lat_a + lat_b) / 2
    elsif lat_a.positive?
      (lat_a + lat_b) > 0 ? (lat_a + lat_b) / 2 : (lat_b + lat_a) / 2
    else
      (lat_b - lat_a) > 0 ? (lat_b + lat_a) / 2 : (lat_a + lat_b) / 2
    end
  end

  def longitude_diff(long_a, long_b)
    sign_check = (long_a.positive? && long_b.positive?) || (long_a.negative? && long_b.negative?)
    if sign_check
      long_a > long_b ? long_a - long_b : long_b - long_a
    elsif long_a.positive?
      (long_a - long_b) > 180 ? (180 - long_a) + (180 + long_b) : long_a - long_b
    else
      (long_b - long_a) > 180 ? (180 - long_b) + (180 + long_a) : long_b - long_a
    end
  end
end
