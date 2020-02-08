require "sqlite3"
require "./db/db_initization.rb"

class Product_Model
  #create one global variable, point to the sqlite3 database..
  # @@db = SQLite3::Database.open "WebshopDb.db"
  @@db_instant = ""

  def Init()
    @@db_instant = Database_Instant.new
  end

  # ---------------------------------------------PRODUCT table, CRUD operation
  def PopulateProducts
    @@db_instant.PopulateProducts
  end

  def UpdateProduct(item_id, product_Name = "", product_Description = "") # called if atleast name needs to be update, description update is optional
    @@db_instant.UpdateProduct
  end

  def InsertProduct(product_Name, product_Description)
    return @@db_instant.InsertProduct
  end

  def DeleteAllProducts
    @@db_instant.DeleteAllProducts
  end

  def DeleteProductByID(itemID)
    @@db_instant.DeleteProductByID(itemID)
  end

  def GetAllProducts
    rs = @@db_instant.GetAllProducts
    return rs
  end

  def GetProductIDByName(product_Name)
    #fetch products by name...
    @@db.results_as_hash = true
    rs = @@db.execute("SELECT * FROM Product where name = ?", product_Name)
    return rs
  end

  # TEST METHODS BELOW.. should be moved to model_test TODO (Phase4)
  def ProductTablesTest()
    puts "\n Products:"
    Init()
    ViewProducts()
  end

  def ViewProducts()
    products = @@db_instant.GetAllProducts
    # products = db_instant.GetProductIDByName("Gloves")
    bExist = false
    products.each do |row|
      # puts row.join "\s"
      id = row["item_id"]
      name = row["name"]
      pDescription = row["desciption"]
      puts "#{name}\thas item_id = #{id}\tand description: #{pDescription} "
      if !bExist
        bExist = true
      end
    end
    if !bExist
      puts "no product exists"
    end
  end

  def InsertProduct(product_name, productDescription)
    @@db_instant.InsertProduct(product_name, productDescription)
  end
end

#Product_Model.new.ProductTablesTest # To run test , to check if model is correctly interacting with DB
