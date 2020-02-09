require_relative "../models/cart_model.rb"
require_relative "../controllers/inventory_manager_controller.rb"

class Shopping_Cart_Controller
  @@inventory_Controller = Inventory_Controller.new
  @@cart_Instance = Cart_Model.new
  @@cartList = []

  def Init()
    @@inventory_Controller.Init
    @@cart_Instance.Init
  end

  def PopulateCartTable(sortBy = "")
    GetAllItemsFromCart()
    #p.name ,i.price, b.item_id, b.quantity
    if @@cartList.any?
      customerTotalPrice = 0
      tableRows = []
      @@cartList.each do |item|
        itemID = item["item_id"]
        name = item["name"]
        qty = item["quantity"]
        iPrice = item["price"]
        iTotalPrice = qty * iPrice
        tableRows << [itemID, name, iPrice, qty, iTotalPrice.round(2)]
        customerTotalPrice += iTotalPrice
      end
      # Insert a footer row...

      tableRows << ["", "", "", "TOTAL: (euros)", customerTotalPrice.round(2)]
      return Terminal::Table.new :title => "Shopping Basket", :headings => ["ID", "Name", "Price (Euros)", "Quantity", "Total Price (Euros)"], :rows => tableRows
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
    @@cart_Instance.AddOrUpdateItemToCart(itemID, qty)
    #need to update the table aswell.
    PopulateCartTable()
    #need to update Quantity in inventory table..
    @@inventory_Controller.UpdateItemQty(itemID.to_i, remainingQty)
  end

  def EmptyCart()
    # delete item from cart, but first update inventory qty
    @@cartList.each do |item|
      itemID = item["item_id"]
      qty = item["quantity"]
      @@inventory_Controller.UpdateInventoryItemQuantity(itemID.to_i, qty.to_i)
    end
    @@cart_Instance.EmptyCart()
    PopulateCartTable()
  end

  def DeleteItem(itemID, remainingQty)
    @@cart_Instance.DeleteItemInCart(itemID)
    PopulateCartTable()
    @@inventory_Controller.UpdateItemQty(itemID.to_i, remainingQty)
  end

  def PopulateInventoryTable(sortBy = "")
    return @@inventory_Controller.PopulateInventoryTable()
  end

  def ExistInInventory(itemID)
    return @@inventory_Controller.ExistInInventory(itemID)
  end

  def GetItemQuantityInInventory(item_id)
    return @@inventory_Controller.GetItemQuantityInInventory(item_id.to_i)
  end
end
