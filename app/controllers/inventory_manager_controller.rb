require_relative "../models/inventory_model.rb"
require_relative "../models/product_model.rb"
require_relative "../controllers/commonFunctions.rb"

#Controller for handling Products and Inventories.
class Inventory_Controller
  @@inventory_Instance = Inventory_Model.new
  @@products_Instance = Product_Model.new

  @@commonFunctions = CommonFunctions.new
  @@inventory_itemsList = []
  @@productsList = []

  # to keep track of sort column and sort order
  @@sort_Column = "" # need to store the state for the column
  @@bAscSort_order = true

  def Init()
    @@inventory_Instance.Init
    @@products_Instance.Init
    @@sort_Column = ""
  end

  # PRODUCT table helper methods
  #Get Products in table format, so that it can be rendered at the terminal view
  def GetAllTheProduct(sortBy = "")
    @@productsList = @@products_Instance.GetAllProducts()
    if !@@sort_Column.empty?
      SortByColumn(@@sort_Column, @@bAscSort_order, false)
    end

    return GetProductTable()
  end

  def IsValidProductID(param_ID)
    # return @@productsList.select { |key, value| key < "b" }
    @@productsList.each do |item|
      itemID = item["item_id"]
      if itemID == param_ID
        return true
      end
    end
    return false
  end

  def AddProduct(name, description)
    newProdID = @@products_Instance.InsertProduct(name, description)
    if newProdID.any?
      return true
    end
    return false
  end

  def UpdateProduct(id, name, description)
    begin
      newProdID = @@products_Instance.UpdateProduct(id, name, description)
      return true
    rescue SystemCallError
      return false
    end
  end

  def DeleteProduct(item_ID)
    begin
      @@products_Instance.DeleteProductByID(item_ID)
      return true
    rescue SystemCallError
      return false
    end
  end

  def IsProductWithNameAlreadyExist(productName)
    @@productsList.each do |item|
      name = item["name"]
      itemID = item["item_id"]

      if name.to_s.upcase == productName.to_s.upcase
        return itemID
      end
    end
    return -1
  end

  def GetProductTable()
    # tableRows = []
    # @@productsList.each do |item|
    #   itemID = item["item_id"]
    #   name = item["name"]
    #   description = item["desciption"]
    #   tableRows << [itemID, name, description]
    # end
    # DisplaySortInformation()

    # return Terminal::Table.new :title => "Products", :headings => ["ID", "Name", "Description"], :rows => tableRows
    return @@commonFunctions.GetPageItemFromTable(@@commonFunctions.Table_Products, @@productsList)
  end

  def DisplaySortInformation()
    if !@@sort_Column.empty?
      sort_order = @@bAscSort_order ? "Ascending" : "Descending"
      puts "Sort On Column: #{@@sort_Column}, order: (#{sort_order})"
    end
  end

  # INVENTORY table helper methods
  #Sortby contains column name by which data is requested to be sorted , by default, its empty, meaning data will be sorted by item id
  #returns tabular form
  def PopulateInventoryTable(bForShoppingView)
    @@inventory_itemsList = @@inventory_Instance.GetAllInventoryItems
    if !@@sort_Column.empty?
      SortByColumn(@@sort_Column, @@bAscSort_order)
    end
    if !bForShoppingView
      return GetInventoryTable()
    else
      "puts here"
      return InventoryTable()
    end
  end

  def GetInventoryTable()
    return @@commonFunctions.GetPageItemFromTable(@@commonFunctions.Table_Inventory, @@inventory_itemsList)
  end

  def InventoryTable()
    tableRows = []
    @@inventory_itemsList.each do |item|
      itemID = item["item_id"]
      name = item["name"]
      qty = item["quantity"]
      iPrice = item["price"]
      extraNotes = item["extraNotes"]
      tableRows << [itemID, name, iPrice, qty, extraNotes]
    end
    return Terminal::Table.new :title => "Inventory", :headings => ["ID", "Name", "Price (Euros)", "Quantity", "Extra Notes"], :rows => tableRows
  end

  def UpdateInventoryItem(item_id, price = -1, quantity = -1, extraNotes = "")
    @@inventory_Instance.UpdateInvetoryItem(item_id, price, quantity, extraNotes)
  end

  def UpdateInventoryItemQuantity(itemID, qty) #Called by shopping_cart_controller.empty cart, to restore the inventory item quantity
    @@inventory_Instance.UpdateInventoryItemQuantity(itemID, qty)
  end

  def UpdateItemQty(itemID, quantity)
    @@inventory_Instance.UpdateItemQty(itemID, quantity)
  end

  def DeleteItemFromInventory(item_id)
    @@inventory_Instance.DeleteInventoryItem(item_id)
  end

  def ExistInInventory(param_ID)
    @@inventory_itemsList.each do |item|
      itemID = item["item_id"]
      if itemID == param_ID
        return true
      end
    end
    return false
  end

  def GetItemQuantityInInventory(param_ID)
    @@inventory_itemsList.each do |item|
      itemID = item["item_id"]
      qty = item["quantity"]
      if itemID == param_ID
        return qty.to_i
      end
    end
    return -1
  end

  def SortByColumn(columnName, bAsc = true, bFromInventoryView = true)
    @@sort_Column = columnName # need to store the state for the column
    @@bAscSort_order = bAsc
    if bFromInventoryView
      @@inventory_itemsList = @@commonFunctions.GetSortedList(@@inventory_itemsList, columnName, bAsc)
      return GetInventoryTable()
    else
      @@productsList = @@commonFunctions.GetSortedList(@@productsList, columnName, bAsc)
      return GetProductTable()
    end
  end

  def FilterByColumn(columnSelected, name, minValue, maxValue, bFromInventoryView = true)
    if bFromInventoryView
      @@inventory_itemsList = @@commonFunctions.GetFilteredList(@@inventory_itemsList, columnSelected, name, minValue, maxValue)
      return GetInventoryTable()
    else
      @@productsList = @@commonFunctions.GetFilteredList(@@productsList, columnSelected, name, minValue, maxValue)
      return GetProductTable()
    end
  end

  def InitializePage(itemsPerPage)
    @@commonFunctions.IntializePageDisplay(itemsPerPage)
  end

  def ChangePage(bToNextPage)
    if bToNextPage
      @@commonFunctions.NextPage()
    else
      @@commonFunctions.PreviousPage()
    end
  end

  def SetProductTable(table)
  end
end
