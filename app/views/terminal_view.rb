# require_relative "../controllers/welcome_terminal_controller.rb"
require_relative "./shopping_view.rb"
require_relative "./management_view.rb"
require_relative "../controllers/shopping_cart_controller.rb"

class Termainal_View
  @@options = "\nPress 1 to shop\nPress 2 to manage inventory\nPress 3 to buy items and exit\n" +
              "Press 4 to exit\n" +
              "Press 'P' (at any time) to set items to view per page\n" +
              "Press 'A' (at any time) see the table/Options for that module again"   #by default, view all items in one page"

  def Init()
    managementView = Management_View.new
    shoppingCartView = Shopping_Cart_View.new
    @@cart_Controller = Shopping_Cart_Controller.new
    puts "\n\n\t\tWelcome to terminal edition of Kwiki Mart"
    puts @@options
    input = 0

    while true
      bDisplayInvalidOption = false # display text if invalid option is selected
      input = gets.chomp
      bIsIntegerEntered = Integer(input) rescue false # try catch equilent to see whether input is integer or string
      if bIsIntegerEntered
        #  break if input.to_i == 3
        if input.to_i == 1 # TODO
          # to the shopping cart
          shoppingCartView.Init
          shoppingCartView.Run
          puts @@options
        elsif input.to_i == 2 # Done
          # to management panel
          managementView.Init
          managementView.Run
          puts @@options
        elsif input.to_i == 3
          #empty just the cart items and exit
          @@cart_Controller.EmptyCart(true)
          print "Thankyou for shopping at our shop. "
          break
        elsif input.to_i == 4
          #empty cart and exit
          @@cart_Controller.EmptyCart()
          break
        else
          bDisplayInvalidOption = true
        end
      else
        if input.to_s.upcase == "P"
          puts "PAGINATION"  #Todo
        elsif input.to_s.upcase == "A"
          puts @@options #Todo
        else
          bDisplayInvalidOption = true
        end
      end
      if bDisplayInvalidOption
        print "Invalid option, try again: "
      end
    end

    puts "Goodbye! Come again!"
    return
  end
end

Termainal_View.new.Init
