# This has been moved to models folder, at the moment , under _model files but has to be moved in _model_test in PHASE 4, (8.2.18:21)
require_relative "db_initization"
require "active_support/core_ext"
# Now using above class to create objects

class Test
  def Go()
    db_instant = Database_Instant.new
    #db_instant.Intialize_DB

    ProductTablesTest(db_instant)
    InventoryTableTest(db_instant)
    BasketTableTest(db_instant)
  end

  # Product operation
  def ProductTablesTest(db_instant)
    puts "\n Products:"
    #Trucate data
    #db_instant.DeleteAllProducts
    #db_instant.DeleteProductByID(1)
    #Insert some products..
    #InsertProduct("Talvi Taakki", "Winter jacket, blue color", db_instant)
    # InsertProduct("Gloves", "Gloves, black color", db_instant)
    # InsertProduct("HAIBIKE 2", "XL Sze", db_instant)
    #UpdateProduct(db_instant, 2, "", "blue color")
    ViewProducts(db_instant)
  end

  def UpdateProduct(db_instant, itemID, product_name, productDescription = "")
    db_instant.UpdateProduct(itemID, product_name, productDescription)
  end

  def InsertProduct(product_name, productDescription, db_instant)
    db_instant.InsertProduct(product_name, productDescription)
  end

  def ViewProducts(db_instant)
    products = db_instant.GetAllProducts
    # products = db_instant.GetProductIDByName("Gloves")
    bExist = false
    products.each do |row|
      # puts row.join "\s"
      id = row["item_id"]
      name = row["name"]
      pDescription = row["desciption"]
      puts "#{name}\thas item_id = #{id}\tand description: #{pDescription} "
      if !bExist
        bExist = true
      end
    end
    if !bExist
      puts "no product exists"
    end
  end

  # INVENTORY Operations ...
  def InventoryTableTest(db_instant)
    puts "\n Inventory:"

    #db_instant.ClearInventory
    #AddItemInInventory("Talvi Taakki ", 2, 39, "very nice jacket, please buy", db_instant)
    #AddItemInInventory("HAIBIKE 2", 1, 349.99, "Cool bike", db_instant)
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

  # Shopping basket Operations ...
  def BasketTableTest(db_instant)
    puts "\n Shopping Basket Items:"
    # DeleteItemsInCart(db_instant)
    # AddItemToCart(db_instant, "HAIBIKE 2", 1)
    # UpdateQtyOfItem(db_instant, itemID, qty)

    # DeleteSpecificItemFromCart(db_instant, itemID)
    #ConfirmPurchase(db_instant)
    #CancelPurchase(db_instant)
    ViewAllItemsInCart(db_instant)
  end

  def DeleteItemsInCart(db_instant)
    db_instant.EmptyCart()
  end

  def AddItemToCart(db_instant, itemName, qty)
    #check if item in that qty exits in the inventory..
    inventory = db_instant.GetAllInventoryItemsByFilters(itemName)
    bExist = false
    inventory.each do |row|
      itemID = row["item_id"]
      item_qty = row["quantity"]
      if item_qty < qty
        puts "#{itemName} is not in stock. Max avaialable pieces: #{item_qty}"
      else
        #Item is avaialable in stock, add to the baseket
        db_instant.AddOrUpdateItemToCart(itemID, qty)
        puts "#{itemName}\tadded to the cart\t(#{qty} piece(s))"
      end

      if !bExist
        bExist = true
      end
    end
    if !bExist
      puts "Product with name #{itemName} doesnot exist. Perhaps add it to Inventory first?"
    end

    #maybe dont remove it from Inventory unless the user confirms (in method ConfirmPurchase/CancelPurchase)
  end

  def ViewAllItemsInCart(db_instant)
    cartItems = db_instant.GetAllItemsFromCart
    bExist = false
    puts "Your Cart:"
    cartItems.each do |item|
      #puts item.join "\s"
      itemID = item["item_id"]
      name = item["name"]
      qty = item["quantity"]
      puts "You have #{qty} piece(s) of:\t#{name}\t( id: #{itemID})"

      if !bExist
        bExist = true
      end
    end
    if !bExist
      puts "Cart is empty, do some shopping?"
    end
  end
end

#EXECUTION
Test.new.Go
########
