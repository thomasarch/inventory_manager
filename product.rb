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
    @sale_price = @price
    @category = array[5]
    @expiry = DateTime.now.next_day(rand(1..31))
    @sale = 1
  end

  attr_accessor :sale
  attr_reader :name, :quantity, :serial_number, :category

  def format_money(num)
    format('$%.2f', (num * 0.01))
  end

  def add_qty(num)
    @quantity += num
  end

  def change_price(num)
    @price = num
  end

  def put_on_sale(num)
    @sale = num * 0.01
    @sale_price = ((1.00 - @sale) * @price).to_i
  end

  def show_info(line)
    puts
    puts line
    puts 'press enter to continue'
    gets
  end

  def price
    format_money(@price)
  end

  def cost
    format_money(@cost)
  end

  def sale_price
    format_money(@sale_price)
  end

  def expiry
    @expiry.strftime('%m/%d/%y')
  end

  def show_total_cost
    show_info("#{@name} total cost: #{format_money(@quantity * @cost)}")
  end

  def show_potential_revenue
    show_info("#{@name} potential revenue: #{format_money(@quantity * @sale_price)}")
  end

  def show_potential_profit
    show_info("#{@name} potential profit: #{format_money((@quantity * @sale_price) - (@quantity * @cost))}")
  end

  def show_sale
    "#{(@sale * 100).to_i}\%"
  end
end
