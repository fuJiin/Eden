require "yaml"

string = "users:
  elpizo:
    name: elpizo
    email: test@tester.com
  francis:
    name: francis
    email: kabuko@gmail.com
  justin:
    name: justin
    email: jlouie@narble.com"
@db = File.open("database.yml", "w")
@db << string
