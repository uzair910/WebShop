2
require "sqlite3"
require "./db/db_initization.rb"

class Cart_Model
  #create one global variable, point to the sqlite3 database..
  @@db_instant = ""

  def Init()
    @@db_instant = Database_Instant.new # new instant of the class
  end

  # ---------------------------------------------Basket table, CRUD operation
  def GetAllItemsFromCart
    # fetch inventory items...
    return @@db_instant.GetAllItemsFromCart
  end

  def EmptyCart
    @@db_instant.EmptyCart
  end

  def AddOrUpdateItemToCart(itemID, quantity)
    @@db_instant.AddOrUpdateItemToCart(itemID, quantity)
  end

  ## TEST METHODS BELOW.. should be moved to model_test TODO (Phase4)
  def BasketTableTest()
    puts "\n Shopping Basket Items:"
    Init()
    #DeleteItemsInCart()
    #AddItemToCart("HAIBIKE 2", 1)
    #UpdateQtyOfItem("HAIBIKE 2", 2)

    # DeleteSpecificItemFromCart(db_instant, itemID)
    #ConfirmPurchase(db_instant)
    #CancelPurchase(db_instant)
    ViewAllItemsInCart()
  end

  def DeleteItemsInCart()
    @@db_instant.EmptyCart()
  end

  def DeleteItemInCart(itemID)
    @@db_instant.DeleteItemByID(itemID)
  end

  def AddItemToCart(itemName, qty)
    #check if item in that qty exits in the inventory..
    inventory = @@db_instant.GetAllInventoryItemsByFilters(itemName)
    bExist = false
    inventory.each do |row|
      itemID = row["item_id"]
      item_qty = row["quantity"]
      if item_qty < qty
        puts "#{itemName} is not in stock. Max avaialable pieces: #{item_qty}"
      else
        #Item is avaialable in stock, add to the baseket
        @@db_instant.AddOrUpdateItemToCart(itemID, qty)
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

  def ViewAllItemsInCart()
    cartItems = @@db_instant.GetAllItemsFromCart
    bExist = false
    puts "Your Cart:"
    cartItems.each do |item|
      #puts item.join "\s"
      itemID = item["item_id"]
      name = item["name"]
      qty = item["quantity"]
      totalPrice = qty * item["price"]

      puts "You have #{qty} piece(s) of:\t#{name}\t( id: #{itemID})\tTotal Price: #{totalPrice}"

      if !bExist
        bExist = true
      end
    end
    if !bExist
      puts "Cart is empty, do some shopping?"
    end
  end

  #Just used by test  for now
  def UpdateQtyOfItem(itemName, quantity)
    inventory = @@db_instant.GetAllInventoryItemsByFilters(itemName)
    bExist = false
    inventory.each do |row|
      itemID = row["item_id"]
      item_qty = row["quantity"]
      if item_qty < quantity
        puts "#{itemName} is not in stock. Max avaialable pieces: #{item_qty}"
      else
        #Item is avaialable in stock, add to the baseket
        @@db_instant.AddOrUpdateItemToCart(itemID, quantity)
        totalPrice = quantity * row["price"]
        puts "#{itemName}\tadded to the cart\t(#{quantity} piece(s)).\tTotal Price: #{totalPrice}"
      end

      if !bExist
        bExist = true
      end
    end
    if !bExist
      puts "Product with name #{itemName} doesnot exist. Perhaps add it to Inventory first?"
    end
  end
end

#Cart_Model.new.BasketTableTest # To run test , to check if model is correctly interacting with DB
