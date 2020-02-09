require "sqlite3"
require "./db/db_initization.rb"

class Inventory_Model
  #create one global variable, point to the sqlite3 database..
  @@db_instant = ""

  def Init()
    @@db_instant = Database_Instant.new
  end

  # ---------------------------------------------Inventory table, CRUD operation (item_id INTEGER NOT NULL,price NUMERIC  NOT NULL,quantity INTEGER ,extraNotes TEXT)
  def InsertOrUpdateItemInInventory(item_id, price, quantity, extraNotes) # either inserts new item in inventory, or updates the quantity if already exists
    @@db_instant.InsertOrUpdateItemInInventory(item_id, price, quantity, extraNotes)
  end

  def UpdateInvetoryItem(item_id, price, quantity, extraNotes)
    @@db_instant.InsertOrUpdateItemInInventory(item_id, price, quantity, extraNotes)
  end

  def UpdateItemPrice(item_id, price)
    @@db_instant.UpdateItemPrice(item_id, price)
  end

  def DeleteInventoryItem(itemID)
    @@db_instant.DeleteInventoryItem(itemID)
  end

  def ClearInventory
    @@db_instant.ClearInventory
  end

  def GetAllInventoryItems
    return @@db_instant.GetAllInventoryItems
  end

  #if some filter is provided
  #cater for name, or price range
  def GetAllInventoryItemsByFilters(itemName, startPrice = 0, endPrice = 0)
    return @@db_instant.GetAllInventoryItemsByFilters(itemName, startPrice, endPrice)
  end

  # TEST METHODS BELOW.. should be moved to model_test TODO (Phase4)
  def InventoryTableTest()
    puts "\n Inventory:"
    Init()
    #DeleteInventoryItem(3)
    #AddItemInInventory("Hawkers Glasses", 40, 19.99, "best biking glasses")
    ViewInventory()
  end

  def AddItemInInventory(item_Name, quantity, price, notes)
    # #Insert some inventroy.. e.g gloves, if they exists in product table.
    products = @@db_instant.GetProductIDByName(item_Name)
    bExist = false
    products.each do |row|
      itemID = row["item_id"]
      @@db_instant.InsertOrUpdateItemInInventory(itemID, price, quantity, notes)
      if !bExist
        bExist = true
      end
    end
    if !bExist
      puts "Product with name #{item_Name} doesnot exist. Perhaps add it to Products first?"
    end
  end

  def ViewInventory()
    itemInInventory = @@db_instant.GetAllInventoryItems
    #itemInInventory = @@db_instant.GetAllInventoryItemsByFilters("", 2)
    # puts "Fetched inventory"
    bExist = false
    itemInInventory.each do |item|
      itemID = item["item_id"]
      name = item["name"]
      qty = item["quantity"]
      iPrice = item["price"]
      extraNotes = item["extraNotes"]
      if qty > 0
        puts "#{name}\t(id:#{itemID})\thas price: #{iPrice}, and is in stock (qty:#{qty}) "
      else
        puts "#{name}\t(id:#{itemID})\tis not in stock  at the moment"
      end

      if !bExist
        bExist = true
      end
    end
    if !bExist
      puts "inventory is empty at the moment, perhaps add items first?"
    end
  end
end

Inventory_Model.new.InventoryTableTest # To run test , to check if model is correctly interacting with DB
