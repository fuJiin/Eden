require "yaml"

@db = File.open("database.yml", "r")
@data = YAML.load(@db)

users = @data["users"]

elpizo = []
users.each do |k, v|
  elpizo << users[k] if v["name"] == "elpizo"
end

puts elpizo.inspect