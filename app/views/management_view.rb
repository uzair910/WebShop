require_relative "../controllers/inventory_manager_controller.rb"
require "terminal-table"

class Management_View
  @@inventory_Controller = Inventory_Controller.new

  @@DisplayManagementOption = ""
  @@inventory_Table = []

  def Init # display controls options
    # initialize controller
    @@inventory_Controller.Init
    # would be required again at multiple places so rather declare it globally (IDEALLY should be a private cosnt : NTS : Check if possible)
    @@DisplayManagementOption = "\nPress S to SORT items from inventory\n" +
                                "Press F to FILTER items by price\n" +
                                "Press 1 to ADD products to the inventory\n" +
                                "Press 2 to MANAGE inventory (update quantity, or price)\n" +
                                "Press 3 to MANAGE Products (ADD/DELETE product)\n" +
                                "Press B to go back to main page"
  end

  def Run
    puts "\n\t\tWelcome to your Inventory Management Panel.\n"
    #table format for the inventory..
    @@inventory_Table = @@inventory_Controller.PopulateInventoryTable()
    DisplayInventoryTable()
    puts @@DisplayManagementOption
    bShowOptionsAgain = false
    input = 0
    while true
      print "Enter your choice here: "
      input = gets.chomp
      bIsIntegerEntered = Integer(input) rescue false # try catch equilent to see if input is integer or string
      if bIsIntegerEntered
        case input.to_i
        when 1
          puts "MANAGE Products" #TODO

          bShowOptionsAgain = true
        when 2
          puts "Add/Update products to Inventory!" #DONE!
          InventoryManagement()
          bShowOptionsAgain = true
        when 3
          puts "Delete Items from Inventory" #Todo
          bShowOptionsAgain = true
        else
          print "Oops, you type an invalid option. try again? "
        end
      else
        break if input.to_s.upcase == "B"
        if input.to_s.upcase == "S" #Todo
          puts " SORTING TIME."
        elsif input.to_s.upcase == "F" #Todo
          puts "Filtering TIME"
        elsif input.to_s.upcase == "P" #Todo
          puts "PAGINATION"
        elsif input.to_s.upcase == "A"
          DisplayInventoryTable()
        else
          print "Oops, you type an invalid option. try again? : "
        end
      end
      if bShowOptionsAgain
        puts @@DisplayManagementOption
      end
    end
  end

  def DisplayInventoryTable()
    puts @@inventory_Table
  end

  def ReloadInventoryTable()
    @@inventory_Table = @@inventory_Controller.PopulateInventoryTable() #refecth the table..
    DisplayInventoryTable()
  end

  def InventoryManagement()
    productTable = @@inventory_Controller.GetAllTheProduct()
    puts productTable

    while true
      print "Input ID for the product you want to ADD (or press B to go back): "
      item_id = gets.chomp
      bIsIntegerEntered = Integer(item_id) rescue false # try catch equilent to see if input is integer or string
      if bIsIntegerEntered
        #check if valid it, that is , if it exists in the product table..
        bIsValidID = @@inventory_Controller.IsValidProductID(item_id.to_i)
        if bIsValidID #good, item is found.
          #Check if already exists in inventory, qty will be 0 or more incase item exists..
          itemQty = @@inventory_Controller.GetItemQuantityInInventory(item_id.to_i)
          # puts "ITEM QTY: " + itemQty
          if itemQty > 0
            puts "\nItem ALREADY EXISTS in inventory. Its QUANTITY in stock is #{itemQty}" #under progress
            puts "If you would like to update the quantity, then enter the new quantity below.\nIncase you would like to cancel, press any non-numeric character..."
            newQuantity = gets.chomp
            bIsIntegerEntered = Integer(newQuantity) rescue false # try catch equilent to see if input is integer or string
            if bIsIntegerEntered
              #new quantity entered, update existing inventory item..item_id, price, quantity, extraNotes
              @@inventory_Controller.UpdateInventoryItem(item_id.to_i, -1, newQuantity.to_i)
              ReloadInventoryTable()
            end
          else
            print "Enter quantity (or enter any non-numeric charater to exist) : "
            newQuantity = gets.chomp
            print "Enter Price (or enter any non-numeric charater to exist) : "
            newPrice = gets.chomp
            print "Enter any additional info: "
            extraNotes = gets.chomp
            bIsIntegerEntered = Integer(newQuantity) rescue false # try catch equilent to see if input is integer or string
            if Integer(newQuantity) && Float(newPrice)
              #new quantity entered, insert product to inventory..
              @@inventory_Controller.UpdateInventoryItem(item_id.to_i, newPrice, newQuantity.to_i, extraNotes)
              ReloadInventoryTable()
            end
          end
        else
          puts "Product with the entered ID not found. perhaps create it first." #todo Phase 4. link this to product creation function
        end
      else #wrong id, id cant be a number..
        break if item_id.to_s.upcase == "B"
        if item_id.to_s.upcase == "P" #Todo
          puts "PAGINATION"
        elsif item_id.to_s.upcase == "A" #Todo
          puts productTable
        end
      end
    end
  end
end
