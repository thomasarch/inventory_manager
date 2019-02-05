require 'json'
require 'date'

# defines the product class
class Product
  def initialize(array)
    @name = array[0]
    @quantity = array[1]
    @serial_number = array[2]
    @cost = array[3]
    @price = array[4]
    @category = array[5]
    @expiry = DateTime.now.next_day(rand(1..31))
    @sale = 1
  end

  attr_accessor :price, :sale
  attr_reader :name, :quantity, :serial_number, :cost, :category, :expiry

  def add_qty(num)
    @quantity += num
  end
end
