class CommonFunctions
  ###########################################################################   DECLARATION
  @@table_Cart = "CART"
  @@table_Inventory = "INVENTORY"
  @@table_Products = "PRODUCT"

  #Columns definition
  @@COLUMN_ITEMID = "ITEM_ID"
  @@COLUMN_PRICE = "PRICE"
  @@COLUMN_QUANTITY = "QUANTITY"
  @@COLUMN_NAME = "NAME"
  @@COLUMN_TOTAL_PRICE = "TOTAL_PRICE"
  @@COLUMN_EXTRANOTES = "EXTRANOTES"
  @@COLUMN_DESCRIPTION = "DESCIPTION"
  @@COLUMN_INVALID = "INVALID" # to handle errors

  #For pagination
  @@currentPageNumber = 1
  @@itemsPerPage = -1         #-1 =ALL ITEMS In one page
  @@maxPages = 1

  def SortOption_Cart()
    return "\tPress '1' to SORT by IDs\n" +
             "\tPress '2' to SORT by Price\n" +
             "\tPress '3' to SORT by  Quantity\n" +
             "\tPress '4' to SORT by  Name"
  end

  def SortOption_Product
    return "\tPress '1' to SORT by IDs\n" +
             "\tPress '2' to SORT by Name\n" +
             "\tPress '3' to SORT by Description"
  end

  def SortOption_Inventory
    return "\tPress '1' to SORT by IDs\n" +
             "\tPress '2' to SORT by Name\n" +
             "\tPress '3' to SORT by Price\n" +
             "\tPress '4' to SORT by Quantity"
  end

  def FilterOption_Inventory
    return "\tPress '1' to Filter by Names\n" +
             "\tPress '2' to Filter by Price\n" +
             "\tPress '3' to Filte by Quantity\n"
    # +            "\tPress '4' to SORT by Extra Text"
  end

  def FilterOption_Cart
    return "\tPress '1' to Filter by Names\n" +
             "\tPress '2' to Filter by Price\n" +
             "\tPress '3' to Filter by Quantity"
    #  "\tPress '4' to SORT by Quantity"
  end

  def FilterOption_Product
    return "\tPress '1' to Filter by Names\n" +
             "\tPress '2' to Filter by Description"
    #  "\tPress '4' to SORT by Quantity"
  end

  #getters
  def Table_Cart
    return @@table_Cart.upcase
  end

  def Table_Inventory
    @@table_Inventory.upcase
  end

  def Table_Products
    @@table_Products.upcase
  end

  def Column_Invalid
    @@COLUMN_INVALID.upcase
  end

  # need for sorting...
  def Column_Price
    @@COLUMN_PRICE.upcase
  end

  def Column_Name
    @@COLUMN_NAME.upcase
  end

  ####################################################################    METHODS
  def bIsNumericCol(columnName)
    case columnName.upcase
    when @@COLUMN_ITEMID, @@COLUMN_PRICE, @@COLUMN_QUANTITY, @@COLUMN_TOTAL_PRICE
      return true
    end
    return false
  end

  #GENERIC SORTING METHOD
  def GetSortedList(itemList, columnName, bAsc)
    #Checks is column is text or numeric
    if bIsNumericCol(columnName)
      if bAsc #ascending order
        return itemList.sort_by { |k| k["#{columnName.downcase}"] }
      else #descending order
        return itemList.sort_by { |k| k["#{columnName.downcase}"] }.reverse!
      end
    else
      if bAsc #ascending order                          |a,b| a['name']<=>b['name']
        return itemList.sort! { |a, b| a["#{columnName.downcase}"].downcase <=> b["#{columnName.downcase}"].downcase }
      else #descending order
        return itemList.sort! { |a, b| a["#{columnName.downcase}"].downcase <=> b["#{columnName.downcase}"].downcase }.reverse!
      end
    end
  end

  #GENERIC Fiter METHOD
  def GetFilteredList(itemList, columnName, name, minValue, maxValue)
    #Checks is column is text or numeric
    if bIsNumericCol(columnName) #filter by range
      if maxValue < 0
        maxValue = Integer::MAX
      end
      if minValue < 0
        minValue = 0
      end
      itemList = itemList.select { |k| minValue <= Float(k["#{columnName.downcase}"]) && Float(k["#{columnName.downcase}"]) <= maxValue }
    else #filter by text, like
      itemList = itemList.select { |item| item["#{columnName.downcase}"].downcase.include? name.downcase }
    end
    return itemList
  end

  def GetFilterOptions(table_name)
    case table_name.to_s.upcase
    when @@table_Cart.to_s
      return FilterOption_Cart()
    when @@table_Inventory.to_s
      return FilterOption_Inventory()
    when @@table_Products
      return FilterOption_Product()
    else
      "Error: Not a valid table name"
    end
  end

  def GetSortTableList(table_name)
    case table_name.to_s.upcase
    when @@table_Cart.to_s
      return SortOption_Cart()
    when @@table_Inventory.to_s
      return SortOption_Inventory()
    when @@table_Products
      return SortOption_Product()
    else
      "Error: Not a valid table name"
    end
  end

  def GetFilterColumnName(optionSelected, table_name)
    case table_name.to_s.upcase
    when @@table_Cart.to_s
      return GetFilterColumnNameForCart(optionSelected)
    when @@table_Inventory.to_s
      return GetFilterColumnNameForInventory(optionSelected)
    when @@table_Products.to_s
      return GetFilterColumnNameForProduct(optionSelected)
    else
      "Error: Not a valid table name"
    end
  end

  def GetSortedColumnName(optionSelected, table_name)
    case table_name.to_s.upcase
    when @@table_Cart.to_s
      return GetSelectColumnNameForCart(optionSelected)
    when @@table_Inventory.to_s
      return GetSelectColumnNameForInventory(optionSelected)
    when @@table_Products.to_s
      return GetSelectColumnNameForProduct(optionSelected)
    else
      "Error: Not a valid table name"
    end
  end

  def GetFilterColumnNameForCart(optionSelected)
    begin
      case optionSelected.to_i
      when 1
        return @@COLUMN_NAME
      when 2
        return @@COLUMN_PRICE
      when 3
        return @@COLUMN_QUANTITY
      else
        return "Invalid"
      end
    rescue
      return "Invalid"
    end
  end

  def GetSelectColumnNameForCart(optionSelected)
    begin
      case optionSelected.to_i
      when 1
        return @@COLUMN_ITEMID
      when 2
        return @@COLUMN_PRICE
      when 3
        return @@COLUMN_QUANTITY
      when 4
        return @@COLUMN_NAME
      else
        return "Invalid"
      end
    rescue
      return "Invalid"
    end
  end

  def GetFilterColumnNameForInventory(optionSelected)
    begin
      case optionSelected.to_i
      when 1
        return @@COLUMN_NAME
      when 2
        return @@COLUMN_PRICE
      when 3
        return @@COLUMN_QUANTITY
      when 4
        return @@COLUMN_EXTRANOTES
      else
        return "Invalid"
      end
    rescue
      return "Invalid"
    end
  end

  def GetFilterColumnNameForProduct(optionSelected)
    begin
      case optionSelected.to_i
      when 1
        return @@COLUMN_NAME
      when 2
        return @@COLUMN_DESCRIPTION
      else
        return "Invalid"
      end
    rescue
      return "Invalid"
    end
  end

  def GetSelectColumnNameForInventory(optionSelected)
    begin
      case optionSelected.to_i
      when 1
        return @@COLUMN_ITEMID
      when 2
        return @@COLUMN_NAME
      when 3
        return @@COLUMN_PRICE
      when 4
        return @@COLUMN_QUANTITY
      when 5
        return @@COLUMN_EXTRANOTES
      else
        return "Invalid"
      end
    rescue
      return "Invalid"
    end
  end

  def GetSelectColumnNameForProduct(optionSelected)
    begin
      case optionSelected.to_i
      when 1
        return @@COLUMN_ITEMID
      when 2
        return @@COLUMN_NAME
      when 3
        return @@COLUMN_DESCRIPTION
      else
        return "Invalid"
      end
    rescue
      return "Invalid"
    end
  end

  ##############################################################  PAGINATION

  def IntializePageDisplay(items_per_page)
    @@itemsPerPage = items_per_page
    @@currentPageNumber = 1
  end

  def GetPageItemFromTable(table, list)
    @@maxPages = (list.length() / @@itemsPerPage.to_f).ceil()  # why does this return negative ?
    FixPages() #not sure by maxpage is initialized by -1 always...?
    itemToBeVisiblelist = FetchViewAbleItems(list)
    if table.to_s == @@table_Cart
      return CartTable(itemToBeVisiblelist, list)
    elsif table.to_s == @@table_Inventory
      return InventoryTable(itemToBeVisiblelist)
    end
  end

  def FixPages()
    #just to make sure..
    if @@maxPages.to_i < 0
      @@maxPages = 1
    end
    if @@maxPages.to_i < @@currentPageNumber.to_i
      @@currentPageNumber = @@maxPages
    end
  end

  def FetchViewAbleItems(list)
    filteredList = []
    item_iterator = 0 #counter for items, if this equals to = itemsPerPage, then that means goto next page
    page_Iterator = 1
    startIndex = ((@@currentPageNumber - 1).to_i * @@itemsPerPage.to_i).to_i + 1
    endIndex = startIndex.to_i + @@itemsPerPage.to_i
    if @@itemsPerPage.to_i < 0
      endIndex = list.length()
    end
    puts "#{startIndex} - #{endIndex}  #{@@itemsPerPage}"
    index = 1
    list.each do |item|
      if index.to_i >= startIndex.to_i && index.to_i < endIndex.to_i
        filteredList << item
      end
      index += 1
    end

    return filteredList
  end

  def InventoryTable(list)
    tableRows = []
    list.each do |item|
      itemID = item["item_id"]
      name = item["name"]
      qty = item["quantity"]
      iPrice = item["price"]
      extraNotes = item["extraNotes"]
      tableRows << [itemID, name, iPrice, qty, extraNotes]
    end
    tableRows << ["", "", "", "", ""]
    sPageText = ""
    if @@itemsPerPage.to_i > 0
      sPageText = "Page #{@@currentPageNumber}/#{@@maxPages}"
    else
      sPageText = "Page 1/1"
    end

    tableRows << [sPageText, "", "", "", ""]
    return Terminal::Table.new :title => "Inventory", :headings => ["ID", "Name", "Price (Euros)", "Quantity", "Extra Notes"], :rows => tableRows
  end

  def CartTable(list, originalList)
    customerTotalPrice = 0
    #special  column for cart table: total price, need to make sure its caclulating total for all items , even for those that are outside the table
    originalList.each do |item|
      itemID = item["item_id"]
      qty = item["quantity"]
      iPrice = item["price"]
      iTotalPrice = qty * iPrice
      customerTotalPrice += iTotalPrice
    end

    tableRows = []
    list.each do |item|
      itemID = item["item_id"]
      name = item["name"]
      qty = item["quantity"]
      iPrice = item["price"]
      iTotalPrice = qty * iPrice
      tableRows << [itemID, name, iPrice, qty, iTotalPrice.round(2)]
      # customerTotalPrice += iTotalPrice
    end
    tableRows << ["", "", "", "", ""]
    sPageText = ""
    if @@itemsPerPage.to_i > 0
      sPageText = "Page #{@@currentPageNumber}/#{@@maxPages}"
    else
      sPageText = "Page 1/1"
    end

    tableRows << [sPageText, "", "", "TOTAL: (euros)", customerTotalPrice.round(2)]
    return Terminal::Table.new :title => "Shopping Basket", :headings => ["ID", "Name", "Price (Euros)", "Quantity", "Total Price (Euros)"], :rows => tableRows
  end

  def NextPage()
    if @@maxPages.to_i > @@currentPageNumber.to_i
      @@currentPageNumber += 1
    else
      @@currentPageNumber = @@maxPages
    end
  end

  def PreviousPage()
    if 1 < @@currentPageNumber.to_i
      @@currentPageNumber -= 1
    end
  end
end

#helper class ... For sorting, if max range is not given, then set to to max possible value..
#src="https://gist.github.com/pithyless/9738125.js"
class Integer
  N_BYTES = [42].pack("i").size
  N_BITS = N_BYTES * 16
  MAX = 2 ** (N_BITS - 2) - 1
  MIN = -MAX - 1
end
