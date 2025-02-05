require 'sinatra'
require 'json'
require 'sqlite3'

class IMDApi < Sinatra::Base
  def db_connection
    return @db if @db
    @db = SQLite3::Database.new('imd.sqlite', readonly: true)
    @db.results_as_hash = true
    @db.enable_load_extension(true)
    @db.load_extension('mod_spatialite')
  end

  get '/imd' do
    content_type :json

    lat = params['lat']
    lon = params['lon']
    if lat.nil? || lon.nil?
      status 400
      return { error: "Missing parameters. Both 'lat' and 'lon' are required" }.to_json
    end

    query = <<-SQL
      SELECT * FROM imd
      WHERE ST_Contains(geometry, Transform(MakePoint(?, ?, 4326), 3857))
      LIMIT 1
    SQL

    result = db_connection.execute(query, [lon.to_f, lat.to_f]).first

    if result
      result.delete('geometry')
      result.to_json
    else
      status 404
      { error: "No data found for these coordinates" }.to_json
    end
  end
end
