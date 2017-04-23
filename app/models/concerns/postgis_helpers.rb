module PostgisHelpers
  module Arel
    NamedFunction = ::Arel::Nodes::NamedFunction

    def st_geogfromtext(point)
      NamedFunction.new('ST_GeogFromText', [point])
    end

    def st_dwithin(point1, point2, radius)
      NamedFunction.new('ST_DWithin', [point1, point2, radius])
    end

    def distance_within(point, table_field, radius)
      ewkt_quoted = ::Arel::Nodes::Quoted.new(ewkt(point))
      st_dwithin(st_geogfromtext(ewkt_quoted), table_field, radius)
    end

    # @param point: A RGeo::Geographic::SphericalPointImpl object
    # @return An ewkt formatted point
    def ewkt(point)
      "SRID=#{point.srid}\;#{point.as_text}"
    end
  end
end
