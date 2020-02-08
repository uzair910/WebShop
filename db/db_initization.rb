require "sqlite3"

class Database_Instant
  #create one global variable, point to the sqlite3 database..
  @@db = SQLite3::Database.open "WebshopDb.db"

  def Intialize_DB
    # OpenConnection()
    CreateTables() #start creating tables..
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

  def UpdateProduct(item_id, product_Name = "", product_Description = "") # called if atleast name needs to be update, description update is optional
    @@db.results_as_hash = true
    if product_Description.empty? && !product_Name.empty?
      return ""
    end
    sqlSet = ""
    if !product_Name.nil? && !product_Name.empty?
      sqlSet = " set name = '#{product_Name}'"
    end

    if !product_Description.nil? && !product_Description.empty?
      if !sqlSet.empty?
        sqlSet += ", desciption = '#{product_Description}'"
      else
        sqlSet = " set desciption = '#{product_Description}'"
      end
    end
    @@db.execute "UPDATE Product #{sqlSet} where item_id = #{item_id}"
  end

  def InsertProduct(product_Name, product_Description)
    @@db.results_as_hash = true
    @@db.execute "INSERT INTO Product(name,desciption) VALUES ('#{product_Name}','#{product_Description}')"
    id = @@db.execute "select last_insert_rowid()"
    return id  # last inserted item's id ..
  end

  def DeleteAllProducts
    #populate products...
    @@db.execute "DELETE FROM Product"
  end

  def DeleteProductByID(itemID)
    #populate products...
    @@db.execute "DELETE FROM Product where item_id = #{itemID}"
  end

  def GetAllProducts
    #fetch all products...
    @@db.results_as_hash = true
    rs = @@db.execute "SELECT * FROM Product Order by item_id asc"
    return rs
  end

  def GetProductIDByName(product_Name)
    #fetch products by name...
    @@db.results_as_hash = true
    rs = @@db.execute("SELECT * FROM Product where name = ?  Order by item_id asc", product_Name)
    return rs
  end

  # ---------------------------------------------Inventory table, CRUD operation (item_id INTEGER NOT NULL,price NUMERIC  NOT NULL,quantity INTEGER ,extraNotes TEXT)
  def InsertOrUpdateItemInInventory(item_id, price, quantity, extraNotes) # either inserts new item in inventory, or updates the quantity if already exists
    @@db.results_as_hash = true
    rowid = @@db.execute "INSERT OR IGNORE INTO Inventory(item_id, price, quantity, extraNotes) VALUES(#{item_id},#{price},#{quantity},'#{extraNotes}')"

    # if row id is null or empty, that means the  item already exists in the inventory, hence it we can just update the quantity..
    id = @@db.execute "select last_insert_rowid() as ITEMID" #Check the last ID of the row that was inserted.
    if id[0]["ITEMID"] == 0 #incase the row was not inserted (happens if it exists already, then id will be 0)
      @@db.execute "UPDATE Inventory set quantity = quantity + #{quantity} where item_id = #{item_id}"
    end
  end

  def UpdateItemPrice(item_id, price)
    @@db.results_as_hash = true
    @@db.execute "UPDATE Inventory set price = #{price} where item_id = #{item_id}"
  end

  def DeleteInventoryItem(itemID)
    @@db.execute "DELETE FROM Inventory where item_id = #{itemID}"
  end

  def ClearInventory
    @@db.execute "DELETE FROM Inventory"
  end

  def GetAllInventoryItems
    @@db.results_as_hash = true
    # fetch inventory items...
    rs = @@db.execute "SELECT p.name , i.item_id, i.price, i.quantity, i.extranotes FROM Inventory i join Product p on p.item_id = i.item_id order by i.item_id asc"
    return rs
  end

  #if some filter is provided
  #cater for name, or price range
  def GetAllInventoryItemsByFilters(itemName, startPrice = 0, endPrice = 0)
    @@db.results_as_hash = true
    # fetch inventory items...
    sql = "SELECT p.name , i.item_id, i.price, i.quantity, i.extranotes FROM Inventory i join Product p on p.item_id = i.item_id where 1 = 1"
    if !itemName.nil? && !itemName.empty?
      sql += " AND p.name like '%#{itemName}%'"
    end
    if endPrice > 0
      sql += " AND i.price BETWEEN #{startPrice} AND #{endPrice}"
    elsif startPrice > 0 && endPrice == 0
      sql += " AND i.price > #{startPrice}"
    end
    sql += " order by i.item_id asc"
    rs = @@db.execute sql
    return rs
  end

  # ---------------------------------------------Basket table, CRUD operation
  def GetAllItemsFromCart
    @@db.results_as_hash = true
    # fetch inventory items...
    return @@db.execute "SELECT p.name ,i.price, b.item_id, b.quantity FROM " +
                          " Basket b INNER JOIN Product p on p.item_id = b.item_id " +
                          " INNER JOIN Inventory i on i.item_id = p.item_id " +
                          " ORDER BY b.item_id asc"
    #" Basket b, Product p, Inventory i " +
    #" WHERE b.item_id = i.item_id AND i.item_id = p.item_id"
  end

  def EmptyCart
    @@db.execute "DELETE FROM Basket"
  end

  def AddOrUpdateItemToCart(itemID, quantity)
    @@db.results_as_hash = true
    rowid = @@db.execute "INSERT OR IGNORE INTO Basket (item_id, quantity) VALUES(#{itemID},#{quantity})"

    # if row id is null or empty, that means the  item already exists in the inventory, hence it we can just update the quantity..
    id = @@db.execute "select last_insert_rowid() as ITEMID" #Check the last ID of the row that was inserted.
    if id[0]["ITEMID"] == 0 #incase the row was not inserted (happens if it exists already, then id will be 0)
      @@db.execute "UPDATE Basket set quantity = quantity + #{quantity} where item_id = #{itemID}"
    end
  end

  # ---------------------------------------------Initialziation methods
  #Create tables, perhaps insert some dummy data if need be..?
  def CreateTables()

    #Products/Items .. Description of products
    @@db.execute "CREATE TABLE IF NOT EXISTS Product(item_id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT NOT NULL, desciption TEXT);"

    #Inventory - to keep track of products currently in the store,
    @@db.execute "CREATE TABLE IF NOT EXISTS Inventory(item_id INTEGER NOT NULL  PRIMARY KEY,price NUMERIC  NOT NULL,quantity INTEGER ,extraNotes TEXT);"

    # customer's shopping cart... items that customer chose
    @@db.execute "CREATE TABLE IF NOT EXISTS Basket(item_id INTEGER NOT NULL PRIMARY KEY, quantity INTEGER);"
  end
end
