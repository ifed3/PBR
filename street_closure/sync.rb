require 'json'
require 'date'
require 'pg'

def sync(street_closure_report)
  conn = PG.connect(dbname: 'street_closures')
  for row in street_closure_report['closures']
    line_geom = <<EOS
st_makeline(
  st_transform(ST_Point(cast(#{row['fromCoordinates'][0]} as float), cast(#{row['fromCoordinates'][1]} as float)),:geography::geometry, 4269)"},
  st_transform(ST_Point(cast(#{row['toCoordinates'][0]} as float), cast(#{row['toCoordinates'][1]} as float))::geography::geometry, 4269)"},
)
EOS
    attributes = [
      { column: 'start', value: "'#{Date.strptime(row['startDate'], "%m/%d/%Y ")}'"},
      { column: 'end', value: "'#{Date.strptime(row['endDate'], "%m/%d/%Y ")}'"},
      { column: 'fromAddress', value: "'#{row['fromAddress']}'"},
      { column: 'toAddress', value: "'#{row['toAddress']}'"},
      { column: 'closureType', value: "'#{row['closureType']}'"},
      { column: 'geom', value: line_geom },
    ]
    columns = attributes.map { |att| "'#{att[:column]}'" }.join(",")
    values = attributes.map { |att| "#{att[:value]}" }.join(",")
    query = "insert into street_closures (#{columns}) values (#{values})"
    puts query
    conn.exec(query)
  end
end
