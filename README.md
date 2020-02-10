Simple Backend application for WebShop.
Content of the file:

1) Project Phase
2) ARCHITECTURE DESCRIPTION
3) Guide to run terminal

######################################################################################### Project Phase
Divided the project in to  a few phases:

1) Phase 1
    . Get RoR fw running, with web interface (for future implementation)
    . Create MVC pattern APP
        - Initialize classes
    . CreateDB instant and initiliaze it
2) Phase 2
    . Create terminal View
    . Add navigation between different views (Shopping Cart, Inventory and products)
    . Add operations :
        - Add, Update, Delete Products
        - Add, Update, Delete Products from Inventory
        - Add, Update, Delete Items in Shopping cart
              - Manage item quanitity in inventory depending on the quantity user adds to the cart
              - display message if item is not in stock
    . Add common methods:
          - Sorting
3) Phase 3
    . Add common methods:
          - Filter products by name
          - Filter products by price
    . Add unit test cases
    . Add pagination
    . Improve code where possible

4) Phase 4 Future implementation
    . Create Web interface for the back end


PROGRESS: As of Monday, 10.2.2020 14.00, phase 2 is implemented.

######################################################################################### ARCHITECTURE DESCRIPTION

I tried to follow the MVC pattern.

Along with model, views and controller, I have the DB layer that contains DB operations.
    --> db/db_initization.rb


__________________DATABASE__________________________________________________

Three main tables:
1) PRODUCT    (item_id,name , desciption)
  . Table that contains all the products that exists in the world (e.g)
  . Item ID is primary key and is incremented automatically.
  . We will use this item_id as a foriegn key in the other two tables.
2) INVENTORY  (item_id INTEGER,price ,quantity  ,extraNotes)
  . Keeps track of the
        products available in the shop,
        their price and
        quantity in stock.
3) BASKET     (item_id , quantity )
    . Refers to the current item basket of the customer.

__________________VIEWS_____________________________________________________

I have 3 basic views, Each view to provide interface for each table basically.
    1) views/management_view.rb : Takes care of Inventory operations
        a ADD product to INVENTORY
        b Update product quantity and price in INVENTORY
        c DELETE product from INVENTORY
    2) views/product_management_view.rb : Takes care of Product operations
        a ADD product
        b Update product description
        c DELETE product
    3) views/shopping_view.rb : Takes care of Shopping basket of the customer
        a ADD items to Basket
        b Update existing items in Basket
        c DELETE items from the basket
        d Delete all the items

Then I have implemented a terminal interface view/terminal_view
You can run this to test the application and functionalities


__________________CONTROLLERS___________________________________________________

Current model contains three controllers that are in use....
    1) controller/inventory_manager_controller
        . This controller is used by 2 Views to interact with the models.
        . I have categorized that Products and Inventroy under the same controllorer.

    2) controller/shopping_cart_controller
        . Used by Shopping_View to manage the operations related to the BASKET table. (shopping cart)

    3) controller/commonFunctions
        . I have one more controller with rather unorthadox name. This basically contains all the methods that might be used by all the views. (example: Sorting tables/Filter data and etc)

__________________MODELS________________________________________________________

Each DB table has its on model file. So we got three files here:

    1) models/Cart_model
    1) models/Inventory_model
    3) models/Product.model

Each model file has an instant of db (db/db_initization) that it uses to perform db related operations.



######################################################################################### GUIDE TO TEST TERMINAL


1) You may run the application in terminal (ruby terminal_view.rb)
2) Following is a list of Features that are implemented and the ones that are not implemented:

  1) SORTING                                        : DONE
      a Sorting for all tables is taking place.
      b You have to give command (S/s) and select the column name.
      c Each view uses common function (controller/commonFunctions.GetSortedList)
        This method is generic and all it needs is the hashset of items (table), the column to be used for sorting and the sort order.
  2) ADD/UPDATE and DELETE                           : DONE
      Implemented for all the tables
  3) FILTER on Price range

  4) Filter by product name

  5) Pagination

  6) Unit tests


