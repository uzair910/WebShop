class CommonFunctions
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
  @@COLUMN_INVALID = "Invalid" # to handle errors

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

  def bIsNumericCol(columnName)
    case columnName
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

  #Methods
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

  def SortOption_Cart()
    return "\tPress '1' to SORT by IDs\n" +
             "\tPress '2' to SORT by Price\n" +
             "\tPress '3' to SORT by  Quantity\n" +
             "\tPress '4' to SORT by  Name"
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

  def SortOption_Inventory
    return "\tPress '1' to SORT by IDs\n" +
             "\tPress '2' to SORT by Name\n" +
             "\tPress '3' to SORT by Price\n" +
             "\tPress '4' to SORT by Quantity"
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

  def SortOption_Product
    return "\tPress '1' to SORT by IDs\n" +
             "\tPress '2' to SORT by Name\n" +
             "\tPress '3' to SORT by Description"
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
        puts "ELSE PRODUCT"
        return "Invalid"
      end
    rescue
      return "Invalid"
    end
  end
end
