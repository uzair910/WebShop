require_relative "db_initization"
require "active_support/core_ext"
# Now using above class to create objects

class Test
  def Go()
    db_instant = Database_Instant.new
    # db_instant.Intialize_DB

    #ProductTablesTest(db_instant)

    InventoryTableTest(db_instant)
  end

  def ProductTablesTest(db_instant)
    ## fun with products
    #db_instant.DeleteAllProducts

    #db_instant.PopulateProducts
    #Insert some products..
    # db_instant.InsertProduct("Talvi Taakki ", "Winter jacket, blue color")
    # db_instant.InsertProduct("Gloves", "Gloves, black color")
    # db_instant.InsertProduct("Salmiaki", "400ml, 40%")
    products = db_instant.GetAllProducts
    # products = db_instant.GetProductIDByName("Gloves")
    #first_row = products.next
    # show products:
    bExist = false
    products.each do |row|
      puts row.join "\s"
      if !bExist
        bExist = true
      end
    end
    if !bExist
      puts "no product exists"
    end
  end

  def InventoryTableTest(db_instant) # INVENTORY Table ...
    db_instant.ClearInventory
    # #Insert some inventroy.. e.g gloves, if they exists in product table.
    qty = 5 #define some quantity
    price = 7 #price defined
    extraNotes = "some note"
    products = db_instant.GetProductIDByName("Gloves")
    bExist = false
    products.each do |row|
      itemID = row["item_id"]
      puts itemID.to_s
      db_instant.InsertItemInInventory(itemID, price, qty, extraNotes)
      #db_instant.InsertItemInInventory(, , 5, "some important notes")
      if !bExist
        bExist = true
      end
    end
    if !bExist
      puts "Product doesnot exist. Therefore cannot be added to the inventory"
    end
    puts "lets check the inventory:"
    itemInInventory = db_instant.GetAllInventoryItems
    # puts "Fetched inventory"
    # bExist = false
    itemInInventory.each do |item|
      #puts item.join "\s"
      itemID = item["item_id"]
      name = item["name"]
      qty = item["quantity"]
      iPrice = item["price"]
      extraNotes = item["extraNotes"]
      if qty > 0
        puts "#{name} ( id:  #{itemID} ) has price: #{iPrice}"
      else
        puts "#{name} ( id:  #{itemID} ) is not in stalk  at the moment"
      end

      if !bExist
        bExist = true
      end
    end
    if !bExist
      puts "no product exists"
    end
  end
end

#EXECUTION
Test.new.Go
########
