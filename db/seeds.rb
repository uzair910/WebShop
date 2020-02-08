# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'sqlite3'
#Using sqlite3 to create a database instance..
db = SQLite3::Database.open 'WebshopDb.db'

#Create tables, perhaps insert some dummy data if need be..?

#Products/Items .. Description of products
db.execute "CREATE TABLE IF NOT EXISTS Product(item_id INTEGER PRIMARY KEY,name TEXT NOT NULL, desciption TEXT);"
#xdb.execute "INSERT INTO Product(item_id,name,desciption)VALUES (1,'Winter Takki', 'Blue color jacket, Large size')"

#Inventory - to keep track of products currently in the store,
db.execute "CREATE TABLE IF NOT EXISTS inventory(item_id INTEGER NOT NULL,price NUMERIC  NOT NULL,quantity INTEGER ,extraNotes TEXT);"

# customer's shopping cart... items that customer chose
#db.execute "CREATE TABLE IF NOT EXISTS BASKET(ItemID INTEGER NOT NULL,price TEXT NOT NULL,quantity INTEGER ,extraNotes TEXT);"



 results = db.query "SELECT item_id,name,desciption FROM Product"
# first_result = results.next
# if first_result
#   puts first_result['item_id']
#   # puts "against ID: " +  first_result['item_id'].to_s  + " we got product with name: " + first_result['name']
# else
#   puts 'No results found.'
# end

results.each { |item|
  # puts item
  puts item.join(',')
}

