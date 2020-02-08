require_relative "db_initization"
require "active_support/core_ext"
# Now using above class to create objects

class Test
  def Go()
    db_instant = Database_Instant.new
    #db_instant.Intialize_DB

    puts "\n Products:"
    ProductTablesTest(db_instant)
    puts "\n Inventory:"
    InventoryTableTest(db_instant)
  end

  def ProductTablesTest(db_instant)
    #Trucate data
    #db_instant.DeleteAllProducts

    #Insert some products..
    # InsertProduct("Talvi Taakki", "Winter jacket, blue color")
    # InsertProduct("Gloves", "Gloves, black color")
    # InsertProduct("HAIBIKE 2", "XL Sze")
    ViewProducts(db_instant)
  end

  def InsertProducts(product_name, productDescription, db_instant)
    db_instant.InsertProduct(product_name, productDescription)
  end

  def ViewProducts(db_instant)
    products = db_instant.GetAllProducts
    # products = db_instant.GetProductIDByName("Gloves")
    bExist = false
    products.each do |row|
      # puts row.join "\s"
      name = row["name"]
      pDescription = row["desciption"]
      puts "#{name} , has description: #{pDescription} "
      if !bExist
        bExist = true
      end
    end
    if !bExist
      puts "no product exists"
    end
  end

  def InventoryTableTest(db_instant) # INVENTORY Table ...
    #db_instant.ClearInventory
    #AddItemInInventory("Talvi Taakki ", 2, 39, "very nice jacket, please buy", db_instant)
    AddItemInInventory("HAIBIKE 2", 1, 349.99, "Cool bike", db_instant)
    #db_instant.DeleteInventoryItem(3)
    ViewInventory(db_instant)
  end

  def AddItemInInventory(item_Name, quantity, price, notes, db_instant)
    # #Insert some inventroy.. e.g gloves, if they exists in product table.
    products = db_instant.GetProductIDByName(item_Name)
    bExist = false
    products.each do |row|
      itemID = row["item_id"]
      # db_instant.InsertOrUpdateItemInInventory(itemID, price, quantity, notes)
      # db_instant.UpdateItemPrice(3, 1000.99)
      if !bExist
        bExist = true
      end
    end
    if !bExist
      puts "Product with name #{item_Name} doesnot exist. Perhaps add it to Products first?"
    end
  end

  def ViewInventory(db_instant)
    itemInInventory = db_instant.GetAllInventoryItems
    #itemInInventory = db_instant.GetAllInventoryItemsByFilters("", 500)
    # puts "Fetched inventory"
    bExist = false
    itemInInventory.each do |item|
      #puts item.join "\s"
      itemID = item["item_id"]
      name = item["name"]
      qty = item["quantity"]
      iPrice = item["price"]
      extraNotes = item["extraNotes"]
      if qty > 0
        puts "#{name} ( id:  #{itemID} ) has price: #{iPrice}, and is in stock (qty:#{qty}) "
      else
        puts "#{name} ( id:  #{itemID} ) is not in stock  at the moment"
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

#EXECUTION
Test.new.Go
########
