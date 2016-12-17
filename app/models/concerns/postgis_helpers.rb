module PostgisHelpers
  NamedFunction = Arel::Nodes::NamedFunction

  def ewkt_from_point(point)
    "SRID=#{point.srid}\;#{point.as_text}"
  end

  def geometry(arg)
    NamedFunction.new('Geometry',[arg])
  end

  def geographical_distance_from_query(point, table_field)
    st_distance_sphere(ewkt_from_point(point), geometry(table_field))
  end

  def st_distance_sphere(point1,point2)
    NamedFunction.new('ST_DistanceSphere', [point1, point2])
  end

  ActiveRecord::StatementInvalid
end