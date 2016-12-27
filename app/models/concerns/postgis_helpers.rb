module PostgisHelpers
  module NamedFunctions
    NamedFunction = Arel::Nodes::NamedFunction

    def geometry(arg)
      NamedFunction.new('Geometry',[arg])
    end

    def st_distance_sphere(point1,point2)
      NamedFunction.new('ST_DistanceSphere', [point1, point2])
    end

    def st_geogfromtext(point)
      NamedFunction.new('ST_GeogFromText', [point])
    end

    def st_dwithin(point1, point2, radius)
      NamedFunction.new('ST_DWithin', [point1, point2, radius])
    end
  end

  include NamedFunctions

  Quoted = Arel::Nodes::Quoted

  def ewkt(point)
    "SRID=#{point.srid}\;#{point.as_text}"
  end

  def distance_sphere(point, table_field)
    st_distance_sphere(ewkt(point), geometry(table_field))
  end

  def distance_within(point, table_field, radius)
    st_dwithin(st_geogfromtext(Quoted.new(ewkt(point))), table_field, radius)
  end
end
