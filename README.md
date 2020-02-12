Simple Backend application for WebShop.
Content of the file:

0) Assumptions
1) Project Phase
2) ARCHITECTURE DESCRIPTION
3) Guide to run terminal
4) CHEAT SHEET (commands list)

######################################################################################### Assumptions/Pointers

1) one session. (cart data maintained per one session)
2) Once you set pages, they will be applied to all the tables besides the Inventory table in Shopping View.
    (i might now why this happens by cannot manage to resolve it)

3) If you want to test the terminal view, you can run views/terminal_view.rb

4) The db instant is already in the repository "WebshopDb", and it is accessed by default by the program
        -> There is a lot of room for improvement in the DB layer (naming convention for starters). So please dont hate me if you see go to DB folder

######################################################################################### Project Phase
Divided the project in to  a few phases:

1) Phase 1

    a. Get RoR fw running, with web interface (for future implementation)
    b. Create MVC pattern APP
        - Initialize classes
    c. CreateDB instant and initiliaze it

2) Phase 2

    a. Create terminal View
    b. Add navigation between different views (Shopping Cart, Inventory and products)
    c. Add operations :
        - Add, Update, Delete Products
        - Add, Update, Delete Products from Inventory
        - Add, Update, Delete Items in Shopping cart
              - Manage item quanitity in inventory depending on the quantity user adds to the cart
              - display message if item is not in stock
    d. Add common methods:
          - Sorting, filtering, paging, common function to fetch tabular form of data.
3) Phase 3

    a. Add common methods:
          - Filter products by name
          - Filter products by price
    b. Add pagination
    c. Improve code where possible

4) Phase 4
    a. Add unit test cases
    b. fix the issue of Inventory table In Shopping view
        . declare inventory class in controller layer.
        . add different sorting and pagination controls in it
    c. Move texts to from views to controller/commonfunctions (Centralize repititive components)

Future implementation
    . Create Web interface for the back end
    . Improvement in the DB layer.
                Use configuration file to specify db to be used,
                Divide the table related operations to seperate files, (just like in Views and Model layer)


######################################################################################### ARCHITECTURE DESCRIPTION

I tried to follow the MVC pattern.

Along with model, views and controller, I have the DB layer that contains DB operations.
    --> db/db_initization.rb


__________________DATABASE__________________________________________________

Three main tables:
1) PRODUCT    (item_id,name , desciption)
  a. Table that contains all the products that exists in the world (e.g)
  b. Item ID is primary key and is incremented automatically.
  c. We will use this item_id as a foriegn key in the other two tables.
2) INVENTORY  (item_id INTEGER,price ,quantity  ,extraNotes)
  a. Keeps track of the
      ->  products available in the shop,
      ->  their price and
      ->  quantity in stock.
3) BASKET     (item_id , quantity )
    a. Refers to the current item basket of the customer.

__________________VIEWS_____________________________________________________


I have 3 basic views, Each view to provide interface for each table basically.

    1) views/management_view.rb : Takes care of Inventory operations

        a. ADD product to INVENTORY

        b. Update product quantity and price in INVENTORY

        c. DELETE product from INVENTORY

    2) views/product_management_view.rb : Takes care of Product operations

        a. ADD product

        b. Update product description

        c. DELETE product

    3) views/shopping_view.rb : Takes care of Shopping basket of the customer

        a. ADD items to Basket

        b. Update existing items in Basket

        c. DELETE items from the basket

        d. Delete all the items

Then I have implemented a terminal interface view/terminal_view
You can run this to test the application and functionalities


__________________CONTROLLERS___________________________________________________

Current model contains three controllers that are in use....

    1) controller/inventory_manager_controller
        a. This controller is used by 2 Views to interact with the models.
        b. I have categorized that Products and Inventroy under the same controllorer.

    2) controller/shopping_cart_controller
        a. Used by Shopping_View to manage the operations related to the BASKET table. (shopping cart)

    3) controller/commonFunctions
        a. I have one more controller with rather unorthadox name. This basically contains all the methods that might be used by all the views. (example: Sorting tables/Filter data and etc)

__________________MODELS________________________________________________________

Each DB table has its on model file. So we got three files here:

    1) models/Cart_model
    1) models/Inventory_model
    3) models/Product.model

Each model file has an instant of db (db/db_initization) that it uses to perform db related operations.



######################################################################################### GUIDE TO TEST TERMINAL


1) You may run the application in terminal (ruby terminal_view.rb)
2) Following is a list of Features that are implemented and the ones that are not implemented:

  1) SORTING                                                                            : DONE
    a. Sorting for all tables is taking place.
            -> Controller/CommonFunctions.GetSortedList
    b. You have to give command (S/s) and select the column name and sort order.
    c. Each view uses common function (controller/commonFunctions.GetSortedList)
            ->  This method is generic and all it needs is the hashset of items (table), the column to be used for sorting and the sort order.
  2) ADD/UPDATE and DELETE                                                              : DONE
    a. Implemented for all the tables
  3) FILTER by Price or quantity (including min/max range)                              : DONE
  4) Filter by product name                                                             : DONE
    a. Centralized method used by all view
        -> Controller/CommonFunctions.GetFilteredList
    b. It takes the column name, and price range value and product name
    c. Then it detects the column typ (Int, numeric or text)
        -> if its text, it takes paramter name and does string comparision
                (matching case, and not case sensitive)
        -> If number is detected, it compares the range using
                min and max values entered from the console.

  5) Pagination                                                                         : DONE (90%)
        . left for the Inventory table inside Shopping view

  6) Unit tests                                                                         : PENDING


######################################################################################### CHEAT SHEET
Terminal commands in different view:


You can press anytime :
        A to view the table and options again, and
        B to go back to previous view

1) FOR Terminal View:

Press 1 to shop                                                                 (Opens shopping cart)
Press 2 to manage inventory                                                     (Opens inventory management, you can browse to product management from here)
Press 3 to buy items and exit                                                   (confirm items purchase and quit. items in basket will be purchased)
Press 4 to exit                                                                 (basket items will be returned to inventory)
Press 'P' (at any time) to set items to view per page
        Press 'N to goto next page
        Press 'L to goto previous page
Press 'A' (at any time) see the table/Options for that module again

2) Shopping Cart View:

Press 'S' to SORT items in the table                        :sort rows
Press 'F' to FILTER items by price                          :filter data
Press 'B' to go back to main page                           :navigate back to main screen
Press 'C' to View your CART                                 :view cart
Press 'I' to See the inventory                              :View the inventory , products available in the shop
Press 1 to ADD/UPDATE items to your cart
Press 2 DELETE Items from your Cart
Press 3 to Empty your cart                                  : DELETE ALL ITEMS from the CART

3) Inventory management View:

Press 'S' to SORT items in the table                            :sort rows
Press 'F' to FILTER items                                       :filter data
Press 'B' to go back to main page                               :navigate back to main screen
Press 1 to MANAGE Products                                      :navigate to PRODUCT management console
Press 2 to ADD/UPDATE item in Inventory
Press 3 Delete Items from Inventory


4) Product Management View
Press 'S' to SORT items in the table                            :sort rows
Press 'F' to FILTER items                                       :filter data
Press 'B' to go back to main page                               :navigate back to main screen
Press 'A' to go see the options again                           :To see the table and options again
Press 1 to ADD new product
Press 2 to UPDATE existing product
Press 3 DELETE a product


#########################################################################################b

