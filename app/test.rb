require 'yaml'
require_relative 'user_aunt'
test_pass = YAML.load(File.open("data_server/user_sa.yml"))

puts  test_pass["methods"]["Password"]



acc = UserAunt.new("user_sa")
acc.data["methods"]["Pet"]["type"] = "cat"