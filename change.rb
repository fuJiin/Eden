require "yaml"

@db = File.open("database.yml", "r")
@data = YAML.load(@db)
@data["users"]["elpizo"]["name"] = "keke"

File.open("database.yml", "w") {|data| data << @data.to_yaml}

