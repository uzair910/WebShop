require_relative "../models/cart_model.rb"
require_relative "../controllers/inventory_manager_controller.rb"
require_relative "../controllers/commonFunctions.rb"

class Shopping_Cart_Controller
  @@inventory_Controller = Inventory_Controller.new
  @@cart_Instance = Cart_Model.new
  @@cartList = []
  @@commonFunctions = CommonFunctions.new

  #to maintain the sort column and order, so that after CRUD ops on the table, the sort order is no lost
  @@sort_Column = ""
  @@bAscSort_order = true

  def Init()
    @@inventory_Controller.Init
    @@cart_Instance.Init
    @@sort_Column = ""
  end

  def SortByColumn(columnName, bAsc = true)
    @@cartList = @@commonFunctions.GetSortedList(@@cartList, columnName, bAsc)
    @@sort_Column = columnName # need to store the state for the column
    @@bAscSort_order = bAsc
  end

  def PopulateCartTable()
    GetAllItemsFromCart()
    if !@@sort_Column.empty?
      SortByColumn(@@sort_Column, @@bAscSort_order)
    end
    return GetCartTable()
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

  def GetCartTable()
    if @@cartList.any?
      return @@commonFunctions.GetPageItemFromTable(@@commonFunctions.Table_Cart, @@cartList)
    else
      return "\t******\tCart Is EMPTY\t******"
    end
  end

  def GetItemQuantityInCart(param_itemID)
    @@cartList.each do |item|
      itemID = item["item_id"]
      qty = item["quantity"]
      if itemID.to_i == param_itemID.to_i
        return qty
      end
    end
    return 0
  end

  def GetAllItemsFromCart()
    @@cartList = @@cart_Instance.GetAllItemsFromCart #update cart
  end

  def InsertOrUpdateCart(itemID, qty, remainingQty)
    bUpdate = false
    @@cartList.each do |item|
      item_ID = item["item_id"]
      if item_ID.to_i == itemID.to_i
        @@cart_Instance.UpdateCartItemQuantity(itemID.to_i, qty.to_i)
        bUpdate = true
      end
    end
    if !bUpdate
      @@cart_Instance.AddItemToCart(itemID, qty)
    end
    #need to update the table aswell.
    PopulateCartTable()
    #need to update Quantity in inventory table..
    @@inventory_Controller.UpdateItemQty(itemID.to_i, remainingQty)
  end

  def isEmptyCart()
    if @@cartList.empty?
      return true
    else
      return false
    end
  end

  def EmptyCart(bConfirmPurchase = false)
    # delete item from cart, but first update inventory qty
    if @@cartList.empty?
      return
    end
    if (!bConfirmPurchase) #If users bought items, and quit, then dont update the inventory.
      @@cartList.each do |item|
        itemID = item["item_id"]
        qty = item["quantity"]
        @@inventory_Controller.UpdateInventoryItemQuantity(itemID.to_i, qty.to_i)
      end
    end
    @@cart_Instance.EmptyCart()
    PopulateCartTable()
  end

  def DeleteItem(itemID, remainingQty)
    @@cart_Instance.DeleteItemInCart(itemID)
    PopulateCartTable()
    @@inventory_Controller.UpdateInventoryItemQuantity(itemID.to_i, remainingQty.to_i)
  end

  def PopulateInventoryTable(sortBy = "")
    return @@inventory_Controller.PopulateInventoryTable(false)
  end

  def GetAllInventoryItemsForShoppingView() # need another method for shopping view since
    return @@inventory_Controller.PopulateInventoryTable(true)
  end

  def ExistInInventory(itemID)
    return @@inventory_Controller.ExistInInventory(itemID)
  end

  def GetItemQuantityInInventory(item_id)
    return @@inventory_Controller.GetItemQuantityInInventory(item_id.to_i)
  end

  def FilterByColumn(columnSelected, name, minValue, maxValue)
    @@cartList = @@commonFunctions.GetFilteredList(@@cartList, columnSelected, name, minValue, maxValue)
    return GetCartTable()
  end
end
