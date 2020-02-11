require_relative "../controllers/inventory_manager_controller.rb"
require_relative "../controllers/commonFunctions.rb"
require "terminal-table"

class Prodcut_Management_View
  #Declare global variables
  @@inventory_Controller = Inventory_Controller.new

  @@commonFunctions = CommonFunctions.new
  @@DisplayManagementOption = ""
  @@product_table = []

  def Init(product_table)
    DisplayWelcomeMessage()
    # @@product_table = product_table
    @@product_table = @@inventory_Controller.GetAllTheProduct()
    DisplayTable()
    @@DisplayManagementOption = "\nPress 'S' to SORT items in the table\n" +
                                "Press 'F' to ADD FILTER/ 'R' to remove all the filters \n" +
                                "Press 'B' to go back to Inventory Management\n" +
                                "Press 'A' to go see the options again\n" +
                                "Press 1 to ADD new product\n" +
                                "Press 2 to UPDATE existing product\n" +
                                "Press 3 DELETE a product"
  end

  def Run(product_table)
    Init(product_table)
    @@inventory_Controller.GetAllTheProduct()
    # @@inventory_Controller.SetProductTable(@@product_table)
    DisplayOpions()
    bAskAgain = false #after a successfull operation, ask user again what to do..
    print "Type Option here: "
    while true
      input = gets.chomp
      bIsIntegerEntered = Integer(input) rescue false # try catch equilent to see if input is integer or string
      if bIsIntegerEntered
        case input.to_i
        when 1
          # ADD                       #done
          AddProduct()
          bAskAgain = true
        when 2
          # UPDATE                    #done
          UpdateProduct()
          bAskAgain = true
        when 3
          #Delete                     #done
          DeleteProduct()
          bAskAgain = true
        else
          print "You enetered an invalid option. Try again or press 'A' to see the options again: "
        end
      else
        break if input.to_s.upcase == "B"
        if input.to_s.upcase == "A"
          DisplayTable()
          DisplayOpions()
          bAskAgain = true
        elsif input.to_s.upcase == "S"
          SortProducts()
          bAskAgain = true
        elsif input.to_s.upcase == "F"
          FilterProducts()
          bAskAgain = true
        elsif input.to_s.upcase == "R"
          FetchAllProdcuts()
          DisplayTable()
          bAskAgain = true
        elsif input.to_s.upcase == "P"
          InitiliazePages()
        elsif input.to_s.upcase == "N"
          ChangePage(true)
        elsif input.to_s.upcase == "L"
          ChangePage(false)
        else
          print "You enetered an invalid option. Try again or press 'A' to see the options again: "
        end
      end
      if bAskAgain
        print "What would you like to do next? (press 'A' to see the options again): "
        bAskAgain = false
      end
    end
  end

  def UpdateProduct
    puts "Lets UPDATE a product. You can just type 'B' to go back and cancel this operation."
    productID = -1

    while true
      print "\tEnter either Product Name or product's ID for the product you want to update: "
      productName = gets.chomp
      #product name cannot be null
      if productName.nil? || productName.empty?
        puts "\tName cannot be empty. Lets try again.."
        next
      end
      # Can check if id is entered or the name, ID will be numeric..
      bIsIntegerEntered = Integer(productName) rescue false # try catch equilent to see if input is integer or string
      if bIsIntegerEntered
        productID = productName.to_i
        if !@@inventory_Controller.IsValidProductID(productID)
          print "\tProduct with the ID: #{productName} doesnot exist. Try again or just press 'B' to cancel/go back"
          next
        end
      else
        if productName.to_s.upcase == "B" # cancel operation
          break
        elsif productName.to_s.upcase == "A" # display produc table operation
          DisplayTable()
          next
        end
        if productName.nil? || productName.empty?
          puts "\tName cannot be empty. Lets try again.."
          next
        end
        productID = @@inventory_Controller.IsProductWithNameAlreadyExist(productName)
        if productID < 0
          puts "\tProduct with the name #{productName} doesnot exist. Try again or just press 'B' to cancel/go back"
          next
        end
      end
      #Can update product now, since now we know the ITEM ID..lets fetch the product name and description
      print "\tEnter new Product Name (leave empty if you dont want to update the name): "
      newProductName = gets.chomp
      print "\tEnter new Product Description: "
      newDescription = gets.chomp
      if @@inventory_Controller.UpdateProduct(productID, newProductName, newDescription)
        puts "\tPRODUCT DELETED SUCCESSFULLY: "
        FetchAllProdcuts()
        DisplayTable()
        break
      end
    end
  end

  def DeleteProduct
    puts "Lets DELETE a product. You can just type 'B' to go back and cancel this operation."
    productID = -1
    while true
      print "\tEnter either Product Name or product's ID: "
      productName = gets.chomp
      #product name cannot be null
      if productName.nil? || productName.empty?
        puts "\tName cannot be empty. Lets try again.."
        next
      end
      # Can check if id is entered or the name, ID will be numeric..
      bIsIntegerEntered = Integer(productName) rescue false # try catch equilent to see if input is integer or string
      if bIsIntegerEntered
        productID = productName.to_i
        if !@@inventory_Controller.IsValidProductID(productID)
          print "\tProduct with the ID: #{productName} doesnot exist. Try again or just press 'B' to cancel/go back"
          next
        end
      else
        if productName.to_s.upcase == "B" # cancel operation
          break
        end
        productID = @@inventory_Controller.IsProductWithNameAlreadyExist(productName)
        if productID < 0
          puts "\tProduct with the name #{productName} doesnot exist. Try again or just press 'B' to cancel/go back"
          next
        end
      end

      #Can delete function to check if product with same name already exsits or not
      if @@inventory_Controller.DeleteProduct(productID)
        puts "\tPRODUCT DELETED SUCCESSFULLY: "
        FetchAllProdcuts()
        DisplayTable()
        break
      end
    end
  end

  def AddProduct()
    puts "Lets ADD a new product. You can just type 'B' to go back and cancel this operation."

    while true
      print "\tEnter Product Name: "
      productName = gets.chomp
      #product name cannot be null
      if productName.nil? || productName.empty?
        puts "\tName cannot be empty. Lets try again.."
        next
      end
      if productName.to_s.upcase == "B" # cancel operation
        break
      end

      #Can add function to check if product with same name already exsits or not
      itemID = @@inventory_Controller.IsProductWithNameAlreadyExist(productName)
      if itemID > 0
        print "\tProduct with this name already exist. Press 'Y' to create another product with same name? "
        confirm = gets.chomp
        if confirm.upcase != "Y"
          next
        end
      end
      print "\tEnter Some description: "
      productDescription = gets.chomp

      if (@@inventory_Controller.AddProduct(productName, productDescription))
        puts "\tPRODUCT ADDED SUCCESSFULLY"
        FetchAllProdcuts()
        DisplayTable()
        break
      end
    end
  end

  def DisplayWelcomeMessage()
    puts "\n\t\tWelcome to your Product Management Panel.\n"
  end

  def DisplayTable()
    puts @@inventory_Controller.GetProductTable() #refecth the table..
  end

  def DisplayOpions()
    puts @@DisplayManagementOption
  end

  def FetchAllProdcuts()
    @@product_table = @@inventory_Controller.GetAllTheProduct()
  end

  def SortProducts()
    DisplaySortOption()
  end

  def DisplaySortOption()
    puts @@commonFunctions.GetSortTableList(@@commonFunctions.Table_Products)
    print "Type your option: (or press 'B' to go back) "
    optionSelected = gets.chomp
    columnSelected = @@commonFunctions.GetSortedColumnName(optionSelected, @@commonFunctions.Table_Products)
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
      @@product_table = @@inventory_Controller.SortByColumn(columnSelected, bSortOrderAscending, false)

      DisplayTable()
    else
      puts "Cannont sort based on your selection. try again"
    end
  end

  def FilterProducts
    #filter available on col name only (for this table)
    columnSelected = @@commonFunctions.Column_Name
    bSortOrderAscending = true

    # name.. get name...
    print "Enter Product text: "
    productName = gets.chomp
    #Lets filter:
    @@product_table = @@inventory_Controller.FilterByColumn(columnSelected, productName, -1, -1, false)
    DisplayTable()
  end

  def InitiliazePages()
    print "Enter the number of items you would like to see per page: "
    number = gets.chomp
    bIsIntegerEntered = Integer(number) rescue false # try catch equilent to see if input is integer or string
    if bIsIntegerEntered
      @@inventory_Controller.InitializePage(number)
      ReLoadProductTable()
      puts @@DisplayManagementOption
    end
  end

  def ChangePage(bToNextPage)
    @@inventory_Controller.ChangePage(bToNextPage)
    ReLoadProductTable()
  end

  def ReLoadProductTable()
    DisplayTable()
    puts @@DisplayManagementOption
  end
end
