require_relative "../controllers/shopping_cart_controller.rb"
require "terminal-table"

class Shopping_Cart_View
  @@cart_Controller = Shopping_Cart_Controller.new

  @@DisplayManagementOption = ""
  @@inventory_Table = []
  @@cart_table = []

  def Init()
    @@cart_Controller.Init
    # would be required again at multiple places so rather declare it globally (IDEALLY should be a private cosnt : NTS : Check if possible)
    @@DisplayManagementOption = "\nPress 'S' to SORT items in the table\n" +
                                "Press 'F' to FILTER items by price\n" +
                                "Press 'B' to go back to main page\n" +
                                "Press 1 to ADD/UPDATE items to your cart\n" +
                                # "Press 2 to UPDATE item quantity for an Item in your cart\n" +
                                "Press 2 DELETE Items from your Cart\n"
    LoadInventory()
  end

  def Run()
    puts "\n\t\tWelcome to your Cart\n"
    puts LoadCartItem()

    puts @@DisplayManagementOption
    print "Enter choice: "
    while true
      bDisplayInvalidOption = false # display text if invalid option is selected
      input = gets.chomp
      bIsIntegerEntered = Integer(input) rescue false # try catch equilent to see whether input is integer or string
      if bIsIntegerEntered
        #  break if input.to_i == 3
        if input.to_i == 1 # DONE
          # to the shopping cart
          AddItemsToCart()
          print "Enter choice: "
        elsif input.to_i == 2 # DELETE In progres
          # to management panel
        else
          bDisplayInvalidOption = true
        end
      else
        break if input.to_s.upcase == "B"
        if input.to_s.upcase == "P"
          puts "PAGINATION"  #Todo
        elsif input.to_s.upcase == "A"
          puts @@DisplayManagementOption
        elsif input.to_s.upcase == "F"
        else
          bDisplayInvalidOption = true
        end
      end
      if bDisplayInvalidOption
        print "Invalid option, try again: "
      end
    end
  end

  def AddItemsToCart()
    puts "Lets ADD a new item to cart. You can just type 'B' to go back and cancel this operation."
    puts "We have Following items in the market: "
    DisplayInventoryTable()
    while true
      print "\tEnter Item ID that you want to purchase: "
      itemID = gets.chomp
      bIsIntegerEntered = Integer(itemID) rescue false # try catch equilent to see if input is integer or string
      if bIsIntegerEntered
        #Check if valid item , that is if the item exists in the table or not..
        if @@cart_Controller.ExistInInventory(itemID.to_i)
          # Item exist in table..
          #get its quantity
          availableQty = @@cart_Controller.GetItemQuantityInInventory(itemID.to_i)
          #puts "AVAILABE: #{availableQty}"
          if availableQty > 0 #item is in stock, lets continue...
            print "\tEnter Quantity: "
            orderedQty = gets.chomp
            begin
              orderedQty = Integer(orderedQty)
            rescue
              break if itemID.to_s.upcase == "B"
              puts "\tInvalid Quanity input. You can try again"
              next
            end
            #puts "#{orderedQty} and avaialbe #{availableQty}"
            if orderedQty > availableQty
              puts "\tSorry, We have only #{availableQty} items in stock. You cannot buy more than this."
            else
              #Kaikki hyvin, lets process the order..

              #add to the cart, and then update qty in the inventory
              remainingItems = availableQty.to_i - orderedQty.to_i
              puts "\tProcessing your order #{remainingItems}"

              @@cart_Controller.InsertOrUpdateCart(itemID, orderedQty, remainingItems)
              LoadCartItem()
              DisplayCartItems()
              ReloadInventoryTable()
              break
            end
          else
            puts "\tSorry, this item is not in stock at the moment."
          end
        else
          puts "\tInvalid ID, try entering again: "
        end
      else
        break if itemID.to_s.upcase == "B"
        if itemID.to_s.upcase == "P" #Todo
          puts "\tPAGINATION"
        elsif itemID.to_s.upcase == "A"
          DisplayCartItems()
          DisplayInventoryTable()
          puts "\tEnter item ID: "
        else
          puts "\tInvalid ID, try entering again: "
        end
      end
    end
  end

  #Region CART
  def LoadCartItem()
    @@cart_table = @@cart_Controller.PopulateCartTable() #refecth the table..
  end

  def DisplayCartItems()
    puts @@cart_table
  end

  #endregion CART

  #regiion Inventory Management
  def LoadInventory()
    @@inventory_Table = @@cart_Controller.PopulateInventoryTable()
  end

  def DisplayInventoryTable()
    puts @@inventory_Table
  end

  def ReloadInventoryTable()
    @@inventory_Table = @@cart_Controller.PopulateInventoryTable() #refecth the table..
    DisplayInventoryTable()
  end

  #end Inventory Management region
end
