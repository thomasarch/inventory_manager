# defines the prodcut class
class Product
  def initialize(name, quantity, serial_number, cost, price, category, expiry, sale = 1)
    @name, @quantity, @serial_number, @cost, @price, @category, @expiry, @sale = name, quantity, serial_number, cost, price, category, expiry, sale
  end

  attr_accessor :price, :sale
  attr_reader :name, :quantity, :serial_number, :cost, :category, :expiry

  def add_inv(num)
    @quantity += num
  end
end
