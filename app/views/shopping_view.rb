require_relative "../controllers/shopping_cart_controller.rb"
require_relative "../controllers/commonFunctions.rb"
require "terminal-table"

class Shopping_Cart_View
  @@cart_Controller = Shopping_Cart_Controller.new
  @@commonFunctions = CommonFunctions.new

  @@DisplayManagementOption = ""
  @@inventory_Table = []
  @@cart_table = []

  def Init()
    @@cart_Controller.Init
    # would be required again at multiple places so rather declare it globally (IDEALLY should be a private cosnt : NTS : Check if possible)
    @@DisplayManagementOption = "\nPress 'S' to SORT items in the table\n" +
                                "Press 'F' to ADD FILTER/ 'R' to remove all the filters \n" +
                                "Press 'B' to go back to main page\n" +
                                "Press 'C' to View your CART\n" +
                                "Press 'I' to See the inventory\n" +
                                "Press 1 to ADD/UPDATE items to your cart\n" +
                                "Press 2 DELETE Items from your Cart\n" +
                                "Press 3 to Empty your cart\n"
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
        elsif input.to_i == 2 # Done
          # to management panel
          DeleteItem()
        elsif input.to_i == 3 # Done
          # to management panel
          DeleteItem(true)
        else
          bDisplayInvalidOption = true
        end
      else
        break if input.to_s.upcase == "B"
        if input.to_s.upcase == "P"
          puts "PAGINATION"  #Todo
        elsif input.to_s.upcase == "A"
        elsif input.to_s.upcase == "C"
          DisplayCartItems()
        elsif input.to_s.upcase == "I"
          DisplayInventoryTable()
        elsif input.to_s.upcase == "F"
          FilterCart()
        elsif input.to_s.upcase == "R"
          LoadCartItem()
          DisplayCartItems()
        elsif input.to_s.upcase == "S"
          SortCart()
        else
          bDisplayInvalidOption = true
        end
      end
      if bDisplayInvalidOption
        print "Invalid option, try again: "
      else
        DisplayCartItems()
        puts @@DisplayManagementOption
        print "Enter choice: "
      end
    end
  end

  def DeleteItem(bDeleteAll = false)
    #check if cart is not empty
    if (@@cart_Controller.isEmptyCart())
      puts "\t Your cart is already empty"
      return
    end
    if bDeleteAll
      print "\tAre you sure? Press 'Y' delete all items from cart: "
      confirm = gets.chomp
      if confirm.to_s.upcase == "Y"
        @@cart_Controller.EmptyCart()
        puts "\tItems removed"
        LoadCartItem()
        ReloadInventoryTable()
      end
      return
    end
    puts "Lets DELETE items to cart. You can just type 'B' to go back and cancel this operation."
    DisplayCartItems()
    while true
      print "\tEnter Item ID that you want to remove from your cart: "
      itemID = gets.chomp
      bIsIntegerEntered = Integer(itemID) rescue false # try catch equilent to see if input is integer or string
      if bIsIntegerEntered
        if @@cart_Controller.ExistInInventory(itemID.to_i)
          qtyInCart = @@cart_Controller.GetItemQuantityInCart(itemID.to_i)
          @@cart_Controller.DeleteItem(itemID, qtyInCart)
          LoadCartItem()
          ReloadInventoryTable()
          puts "\tItem removed from your cart"
          break
        else
          puts "\tThis item doesnot exist in your cart"
          next
        end
      else
        break if itemID.to_s.upcase == "B"
        if itemID.to_s.upcase == "P" #Todo
          puts "\tPAGINATION"
        elsif itemID.to_s.upcase == "A"
          DisplayCartItems()
          next
        else
          puts "\tInvalid ID, try entering again: "
        end
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

  def SortCart()
    DisplaySortOption()
  end

  def DisplaySortOption()
    puts @@commonFunctions.GetSortTableList(@@commonFunctions.Table_Cart)
    print "Type your option: (or press 'B' to go back) "
    optionSelected = gets.chomp
    columnSelected = @@commonFunctions.GetSortedColumnName(optionSelected, @@commonFunctions.Table_Cart)
    bSortOrderAscending = true
    if columnSelected.upcase != @@commonFunctions.Column_Invalid
      print "Inorder to sort in descending order, press 'D' (press any other key to continue): "
      sortOrder = gets.chomp
      begin
        if sortOrder.upcase.to_s == "D"
          bSortOrderAscending = false
        end
      rescue
      end
      @@cart_table = @@cart_Controller.SortByColumn(columnSelected, bSortOrderAscending)
      @@cart_table = @@cart_Controller.GetCartTable() #refecth the table..
      DisplayCartItems()
    else
      puts "Cannont sort based on your selection. try again"
    end
  end

  def FilterCart
    puts @@commonFunctions.GetFilterOptions(@@commonFunctions.Table_Cart)
    print "Type your option: (or press 'B' to go back) "
    optionSelected = gets.chomp
    columnSelected = @@commonFunctions.GetFilterColumnName(optionSelected, @@commonFunctions.Table_Cart)
    bSortOrderAscending = true
    if columnSelected.upcase != @@commonFunctions.Column_Invalid
      productStartPrice = -1
      productEndPrice = -1
      productName = ""
      if @@commonFunctions.bIsNumericCol(columnSelected.upcase) #columnSelected.upcase != @@commonFunctions.Column_Price #If price selected, need to get start and end price.
        print "Enter Minimum value (you can leave it empty): "
        begin
          productStartPrice = Float(gets.chomp)
        rescue
          productStartPrice = -1
        end
        print "Enter Maximum value (you can leave it empty): "
        begin
          productEndPrice = Float(gets.chomp)
        rescue
          productEndPrice = -1
        end
      else
        # name.. get name...
        print "Enter text: "
        productName = gets.chomp
      end
      #Lets filter:
      @@cart_table = @@cart_Controller.FilterByColumn(columnSelected, productName, productStartPrice, productEndPrice)
      DisplayCartItems()
    else
      puts "Cannont sort based on your selection. try again"
    end
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
