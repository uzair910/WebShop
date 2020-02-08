require_relative "../controllers/welcome_terminal_controller.rb"
require_relative "./shopping_view.rb"
require_relative "./management_view.rb"

class Termainal_View
  def Init()
    managementView = Management_View.new
    puts "\n\n\t\tWelcome to terminal edition of Kwiki Mart"

    input = 0
    while true
      puts "\nPress 1 to shop\nPress 2 to manage inventory\nPress 3 to exit\nPress H to for help/shortcut keys (Pagination etc)"
      input = gets.chomp
      bIsIntegerEntered = Integer(input) rescue false # try catch equilent to see if input is integer or string
      if bIsIntegerEntered
        if input.to_i == 1 # TODO
          #view list..
        elsif input.to_i == 2  # Under Progress
          # to management panel
          managementView.Init
          managementView.Run
        end
      end
    else
      if input.to_s.upcase3 == "H"
        puts "Show Help"  #Todo
      else
    end
    puts "Goodbye! Come again!"
    return
  end
end

Termainal_View.new.Init
