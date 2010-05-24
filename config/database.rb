# Check Rack Environment
case ENV['RACK_ENV']

  # Production Settings for Heroku
  when "production"
    conf = {:db => {'uri' => ENV['MONGOHQ_URL']}}
    MongoMapper.config = conf
    MongoMapper.connect(:db)

  # Development Settings for Local Machine
  when "development"
    MongoMapper.database = "mydb"
end

# Connect GridFS
GRID = Mongo::Grid.new(MongoMapper.database)
