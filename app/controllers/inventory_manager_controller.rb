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

    return Terminal::Table.new :title => "Inventory", :headings => ["ID", "Name", "Price", "Quantity", "Extra Notes"], :rows => tableRows
  end
end
