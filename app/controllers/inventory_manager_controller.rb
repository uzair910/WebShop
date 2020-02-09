require_relative "../models/inventory_model.rb"
require_relative "../models/product_model.rb"
#Controller for handling Products and Inventories.
class Inventory_Controller
  @@inventory_Instance = Inventory_Model.new
  @@products_Instance = Product_Model.new
  @@inventory_itemsList = []
  @@productsList = []

  def Init()
    @@inventory_Instance.Init
    @@products_Instance.Init
  end

  # PRODUCT table helper methods
  #Get Products in table format, so that it can be rendered at the terminal view
  def GetAllTheProduct(sortBy = "")
    @@productsList = @@products_Instance.GetAllProducts
    tableRows = []
    @@productsList.each do |item|
      itemID = item["item_id"]
      name = item["name"]
      description = item["desciption"]
      tableRows << [itemID, name, description]
    end
    return Terminal::Table.new :title => "Products", :headings => ["ID", "Name", "Description"], :rows => tableRows
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
        puts "#{productName} and fetched : #{name} "
        return itemID
      end
    end
    return -1
  end

  # INVENTORY table helper methods
  #Sortby contains column name by which data is requested to be sorted , by default, its empty, meaning data will be sorted by item id
  #returns tabular form
  def PopulateInventoryTable(sortBy = "")
    @@inventory_itemsList = @@inventory_Instance.GetAllInventoryItems
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
end
