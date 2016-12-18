module FakerHelpers
  module Geographic
    def rand_point_within(point, radius)
      begin
        a_point = rand_point
      end while point.distance(a_point) >= radius
      a_point
    end

    def rand_point
      RGeo::Geographic.spherical_factory(srid: 4326).point(FFaker::Geolocation.lng, FFaker::Geolocation.lat)
    end
  end
end