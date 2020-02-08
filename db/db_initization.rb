require "sqlite3"

class Database_Instant
  #create one global variable, point to the sqlite3 database..
  @@db = SQLite3::Database.open "WebshopDb.db"

  def Intialize_DB
    # OpenConnection()
    puts "Creating tables"
    CreateTables() #start creating tables..
    puts "Tables created successfully"
  end

  # ---------------------------------------------PRODUCT table, CRUD operation
  def PopulateProducts
    puts "Inserting Data"
    #populate products...
    @@db.execute "INSERT INTO Product (name,desciption) VALUES ('Winter Takki', 'Blue color jacket, Large size')"
    # id = @@db.execute "select last_insert_rowid()"
    # return id  # last insertid..
    puts "Test product inserted"
  end

  def InsertProduct(product_Name, product_Description)
    @@db.results_as_hash = true
    @@db.execute "INSERT INTO Product(name,desciption) VALUES ('#{product_Name}','#{product_Description}')"

    # @@db.execute "INSERT INTO Product (name, desciption)
    #                VALUES (?, ?)", ["name", product_Name, "desciption", product_Description]

    id = @@db.execute "select last_insert_rowid()"
    return id  # last inserted item's id ..
  end

  def DeleteAllProducts
    #populate products...
    @@db.execute "DELETE FROM Product"
  end

  def GetAllProducts
    #fetch all products...
    @@db.results_as_hash = true
    rs = @@db.execute "SELECT * FROM Product"
    return rs
  end

  def GetProductIDByName(product_Name)
    #fetch products by name...
    @@db.results_as_hash = true
    rs = @@db.execute("SELECT * FROM Product where name = ?", product_Name)
    return rs
  end

  # ---------------------------------------------Inventory table, CRUD operation (item_id INTEGER NOT NULL,price NUMERIC  NOT NULL,quantity INTEGER ,extraNotes TEXT)
  def InsertItemInInventory(item_id, price, quantity, extraNotes)
    @@db.results_as_hash = true
    # @@db.execute "INSERT INTO Inventory(item_id,price, quantity, extraNotes)
    #             VALUES (" + item_id + ", " + price + ", " + quantity + ", '" + extraNotes + "')"
    @@db.execute "INSERT INTO Inventory(item_id, price, quantity, extraNotes) VALUES(#{item_id},#{price},#{quantity},'#{extraNotes}')"
  end

  def ClearInventory
    #populate products...
    @@db.execute "DELETE FROM Inventory"
    puts "data deleted from Inventory table"
  end

  def GetAllInventoryItems
    @@db.results_as_hash = true
    # #populate products...
    rs = @@db.execute "SELECT p.name , i.item_id, i.price, i.quantity, i.extranotes FROM Inventory i join Product p on p.item_id = i.item_id"
    #rs = @@db.execute "SELECT * FROM Inventory "
    return rs
  end

  # def GetItemsWithinPrice(priceTo, priceFrom)
  #   #populate products...
  #   stm = @@db.prepare "SELECT * FROM Inventory"
  #   rs = stm.execute
  #   return rs
  # end

  # def UpdateInventoryItemQuantity
  #   #populate products...
  #   stm = @@db.prepare "SELECT * FROM Inventory"
  #   rs = stm.execute
  #   return rs
  # end

  # ---------------------------------------------Basket table, CRUD operation

  # ---------------------------------------------Initialziation methods
  #Create tables, perhaps insert some dummy data if need be..?
  def CreateTables()
    #Products/Items .. Description of products
    @@db.execute "CREATE TABLE IF NOT EXISTS Product(item_id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT NOT NULL, desciption TEXT);"

    #Inventory - to keep track of products currently in the store,
    @@db.execute "CREATE TABLE IF NOT EXISTS Inventory(item_id INTEGER NOT NULL,price NUMERIC  NOT NULL,quantity INTEGER ,extraNotes TEXT);"

    # customer's shopping cart... items that customer chose
    #db.execute "CREATE TABLE IF NOT EXISTS Basket(ItemID INTEGER NOT NULL,price TEXT NOT NULL,quantity INTEGER ,extraNotes TEXT);"

  end
end
