module Helpers
  def build_location(long, lat)
    begin
      long = Float(long)
      lat = Float(lat)
      unless long.between?(-180,180) and lat.between?(-90,90)
        raise ArgumentError.new('Angles out of bound')
      end
      RGeo::Geographic::spherical_factory(srid: 4326).point(long, lat)
    rescue TypeError, ArgumentError
      nil
    end
  end
end