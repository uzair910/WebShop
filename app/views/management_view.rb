require_relative "../controllers/inventory_manager_controller.rb"
require "terminal-table"
require_relative "./product_management_view.rb"
require_relative "../controllers/commonFunctions.rb"

class Management_View
  @@inventory_Controller = Inventory_Controller.new
  @@commonFunctions = CommonFunctions.new

  @@DisplayManagementOption = ""
  @@inventory_Table = []
  @@product_table = []

  def Init # display controls options
    # initialize controller
    @@inventory_Controller.Init
    # would be required again at multiple places so rather declare it globally (IDEALLY should be a private cosnt : NTS : Check if possible)
    @@DisplayManagementOption = "\nPress 'S' to SORT items in the table\n" +
                                "Press 'F' to FILTER items \n" +
                                "Press 'B' to go back to main page\n" +
                                "Press 1 to MANAGE Products\n" +
                                "Press 2 to ADD/UPDATE item in Inventory\n" +
                                "Press 3 Delete Items from Inventory\n"
    FetchProduct()
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
          ProductManagement()   #DONE
          bShowOptionsAgain = true
        when 2
          InventoryManagement()         #DONE,
          bShowOptionsAgain = true
        when 3
          DeleteItemFromInventory()       #DONE
          bShowOptionsAgain = true
        else
          print "Oops, you type an invalid option. try again? "
        end
      else
        break if input.to_s.upcase == "B"
        if input.to_s.upcase == "S" #DONE
          SortInventory()
          bShowOptionsAgain = true
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

  #region Product Management
  def ProductManagement
    puts "In productManagement"
    productManagementView = Prodcut_Management_View.new
    productManagementView.Run(@@product_table)
  end

  #endregion

  def FetchProduct()
    @@product_table = @@inventory_Controller.GetAllTheProduct()
  end

  def DisplayProductTable()
    puts @@product_table
  end

  #regiion Inventory Management
  def SortInventory()
    puts @@commonFunctions.GetSortTableList(@@commonFunctions.Table_Inventory)
    optionSelected = gets.chomp
    columnSelected = @@commonFunctions.GetSortedColumnName(optionSelected, @@commonFunctions.Table_Inventory)
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
      @@inventory_Table = @@inventory_Controller.SortByColumn(columnSelected, bSortOrderAscending)
      DisplayInventoryTable()
    else
      puts "Cannont sort based on your selection. try again"
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
    DisplayProductTable()

    while true
      print "\tInput ID for the product you want to ADD (or press B to go back): "
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
            puts "\n\tItem ALREADY EXISTS in inventory. Its QUANTITY in stock is #{itemQty}. You can add more stock to the exisitng item.\n"
            puts "\tEnter the quantity below. (press any non-numeric character to cancel operation)"
            print "\tEnter here: "
            newQuantity = gets.chomp
            bIsIntegerEntered = Integer(newQuantity) rescue false # try catch equilent to see if input is integer or string
            if bIsIntegerEntered
              #new quantity entered, update existing inventory item..item_id, price, quantity, extraNotes
              @@inventory_Controller.UpdateInventoryItem(item_id.to_i, -1, newQuantity.to_i)
              ReloadInventoryTable()
              break
            end
          else
            print "\tEnter quantity (or enter any non-numeric charater to exist) : "
            newQuantity = gets.chomp
            print "\tEnter Price (or enter any non-numeric charater to exist) : "
            newPrice = gets.chomp
            print "\tEnter any additional info: "
            extraNotes = gets.chomp
            bIsIntegerEntered = Integer(newQuantity) rescue false # try catch equilent to see if input is integer or string
            if Integer(newQuantity) && Float(newPrice)
              #new quantity entered, insert product to inventory..
              @@inventory_Controller.UpdateInventoryItem(item_id.to_i, newPrice, newQuantity.to_i, extraNotes)
              ReloadInventoryTable()
            end
          end
        else
          puts "\tProduct with the entered ID not found. perhaps create it first." #todo Phase 4. link this to product creation function
        end
      else #wrong id, id cant be a number..
        break if item_id.to_s.upcase == "B"
        if item_id.to_s.upcase == "P" #Todo
          puts "PAGINATION"
        elsif item_id.to_s.upcase == "A" #Todo
          DisplayProductTable()
        else
          puts "\tProduct with the entered ID not found. perhaps create it first." #todo Phase 4. link this to product creation function
        end
      end
    end
  end

  def DeleteItemFromInventory()
    print "\tInput Item ID that you would want to delete (or press 'B' to go back):  "
    while true
      item_id = gets.chomp
      if (Integer(item_id) rescue false)
        if @@inventory_Controller.ExistInInventory(item_id.to_i)
          #confirm message,
          print "\tAre you sure? (Y/N)"
          confirm = gets.chomp
          if confirm.to_s.upcase == "Y"
            @@inventory_Controller.DeleteItemFromInventory(item_id.to_i)
            puts "\tItem with ID #{item_id} DELETED."
            ReloadInventoryTable()
            break
          else
            break #could do something else? PHASE 4
          end
        else
          print "\tInvalid ID, try entering again: "
        end
      else
        break if item_id.to_s.upcase == "B"
        if item_id.to_s.upcase == "P" #Todo
          puts "\tPAGINATION"
        elsif item_id.to_s.upcase == "A"
          DisplayInventoryTable()
          print "\tEnter item ID: "
        else
          print "\tInvalid ID, try entering again: "
        end
      end
    end
  end

  #endregion
end
