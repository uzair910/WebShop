require_relative "../controllers/inventory_manager_controller.rb"
require "terminal-table"

class Management_View
  @@inventory_Controller = Inventory_Controller.new

  def Init # display controls options
    # initialize controller
    @@inventory_Controller.Init
  end

  def Run
    puts "\n\t\tWelcome to your Inventory Management Panel.\n"
    #table format for the inventory..
    inventoryTable = @@inventory_Controller.PopulateInventoryTable()
    puts inventoryTable

    input = 0
    puts "\nPress S to SORT items from inventory\n" +
           "Press F to FILTER items by price\n" +
           "Press 1 to ADD products to the inventory\n" +
           "Press 2 to MANAGE inventory (update quantity, or price)\n" +
           "Press 3 to MANAGE Products (ADD/DELETE product)\n" +
           "Press 4 to go back to main page\n" +
           "Press H to for help/shortcut keys (Pagination etc)"

    while true
      print "Enter your choice here: "
      input = gets.chomp
      bIsIntegerEntered = Integer(input) rescue false # try catch equilent to see if input is integer or string
      if bIsIntegerEntered
        break if input.to_i == 4
        case input.to_i
        when 1
          puts "ADD products" #Under progress
          ProductManagement()
        when 2
          puts "MANAGE inventory!" #Todo
        when 3
          puts " MANAGE Products." #Todo
        else
          print "Oops, you type an invalid option. try again? "
        end
      else
        if input.to_s.upcase == "S" #Todo
          puts " SORTING TIME."
        elsif input.to_s.upcase3 == "F" #Todo
          puts "Filtering TIME"
        elsif input.to_s.upcase3 == "H" #Todo
          puts "Show Help"
        else
          print "Oops, you type an invalid option. try again? : "
        end
      end
    end
  end

  def ProductManagement()
    productTable = @@inventory_Controller.GetAllTheProduct()
    puts productTable
  end
end
