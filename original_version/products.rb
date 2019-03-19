require_relative 'store_classes'
require 'date'

class All_Products
  def self.get
    array = []
    # name, quantity, serial_number, cost, price, category

    array.push(
      Product.new("Pizza Rolls", 36, 345675, 399, 499, "Frozen Foods", DateTime.now.next_day(rand(1..31))),
      Product.new("Red Baron Pizza", 24, 345656, 299, 399, "Frozen Foods", DateTime.now.next_day(rand(1..31))),
      Product.new("Chocolate Ice Cream", 12, 345464, 300, 499, "Frozen Foods", DateTime.now.next_day(rand(1..31))),
      Product.new("French Fries", 12, 345432, 345, 445, "Frozen Foods", DateTime.now.next_day(rand(1..31))),
      Product.new("Veggie Burger", 36, 354657, 350, 499, "Frozen Foods", DateTime.now.next_day(rand(1..31))),

      Product.new("Miller Lite 12pk", 12, 556743, 700, 999, "Beer/Wine", DateTime.now.next_day(rand(1..31))),
      Product.new("Black Box Cabernet", 12, 556789, 1200, 2000, "Beer/Wine", DateTime.now.next_day(rand(1..31))),
      Product.new("Bells Two-Hearted Ale 12pk", 6, 567983, 1300, 1995, "Beer/Wine", DateTime.now.next_day(rand(1..31))),
      Product.new("Samuel Addams Winter Ale 12pk", 12, 593821, 1300, 1995, "Beer/Wine", DateTime.now.next_day(rand(1..31))),
      Product.new("New Belguim Fat Tire 12pk", 12, 592031, 1300, 1995, "Beer/Wine", DateTime.now.next_day(rand(1..31))),

      Product.new("Chicken Breast", 36, 234543, 300, 499, "Meat", DateTime.now.next_day(rand(1..31))),
      Product.new("Ground Beef 1lb", 24, 239185, 255, 455, "Meat", DateTime.now.next_day(rand(1..31))),
      Product.new("Spicy Sausage", 24, 237684, 350, 499, "Meat", DateTime.now.next_day(rand(1..31))),
      Product.new("Pork Chops", 12, 234343, 375, 550, "Meat", DateTime.now.next_day(rand(1..31))),
      Product.new("New York Strip 16oz", 12, 231345, 800, 1299, "Meat", DateTime.now.next_day(rand(1..31))),

      Product.new("New York Strip 16oz", 12, 231345, 800, 1299, "Food", DateTime.now.next_day(rand(1..31)))
    )
    return array

  end
end