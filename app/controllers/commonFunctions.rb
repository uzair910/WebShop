class CommonFunctions
  @@table_Cart = "CART"
  @@table_Inventory = "INVENTORY"
  @@table_Products = "PRODUCTS"
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

  #Methods
  def GetSortTableList(table_name)
    case table_name.to_s.upcase
    when @@table_Cart.to_s
      return SortOption_Cart()
    when @@table_Inventory.to_s
      return "Inventory"
    when @@table_Products
      return "Products"
    else
      "Error: Not a valid table name"
    end
  end

  #BASEKET TABLE

  def GetSortedColumnName(optionSelected, table_name)
    case table_name.to_s.upcase
    when @@table_Cart.to_s
      return GetSelectColumnNameForCart(optionSelected)
    when @@table_Inventory.to_s
      return "Inventory"
    when @@table_Products
      return "Products"
    else
      "Error: Not a valid table name"
    end
  end

  def SortOption_Cart()
    return "\tPress '1' to SORT by IDs\n" +
             "\tPress '2' to SORT by Price\n" +
             "\tPress '3' to SORT by  Quantity\n" +
             "\tPress '4' to SORT by  Total Price\n" +
             "\tPress '5' to SORT by  Name"
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
        return @@COLUMN_TOTAL_PRICE
      when 5
        return @@COLUMN_NAME
      else
        return "Invalid"
      end
    rescue
      return "Invalid"
    end
  end

  #Columns definition
  @@COLUMN_ITEMID = "ITEM_ID"
  @@COLUMN_PRICE = "PRICE"
  @@COLUMN_QUANTITY = "QUANTITY"
  @@COLUMN_NAME = "NAME"
  @@COLUMN_TOTAL_PRICE = "TOTAL_PRICE"
  @@COLUMN_INVALID = "Invalid"
end
