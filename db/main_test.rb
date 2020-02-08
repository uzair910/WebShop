require_relative "db_initization"
require "active_support/core_ext"
# Now using above class to create objects

class Test
  def Go()
    db_instant = Database_Instant.new
    # db_instant.Intialize_DB

    puts "\n Products:"
    ProductTablesTest(db_instant)
    puts "\n Inventory:"
    InventoryTableTest(db_instant)
  end

  def ProductTablesTest(db_instant)
    ## fun with products
    #db_instant.DeleteAllProducts

    #db_instant.PopulateProducts
    #Insert some products..
    # db_instant.InsertProduct("Talvi Taakki ", "Winter jacket, blue color")
    # db_instant.InsertProduct("Gloves", "Gloves, black color")
    # db_instant.InsertProduct("HAIBIKE 2", "XL Sze")
    products = db_instant.GetAllProducts
    # products = db_instant.GetProductIDByName("Gloves")
    #first_row = products.next
    # show products:
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
    #AddItemInInventory("HAIBIKE 2", 1, 3449.99, "very nice bike", db_instant)
    #AddItemInInventory("Gloves", 6, 9.99, "Warmest gloves ever!", db_instant)
    ViewInventory(db_instant)
  end

  def AddItemInInventory(item_Name, quantity, price, notes, db_instant)
    # #Insert some inventroy.. e.g gloves, if they exists in product table.
    products = db_instant.GetProductIDByName(item_Name)
    bExist = false
    products.each do |row|
      itemID = row["item_id"]
      db_instant.InsertItemInInventory(itemID, price, quantity, notes)
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
        puts "#{name} ( id:  #{itemID} ) has price: #{iPrice}, and is in stock"
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
