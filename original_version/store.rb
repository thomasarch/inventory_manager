require_relative 'store_classes'
require_relative 'products'
require 'date'

# name, quantity, serial_number, cost, price, category

@all_products = All_Products.get

@categories = []
@all_products.each do |product|
  @categories.push(product.category)
end
@categories.uniq!

def money(num)
  "$#{'%0.2f'%(num * 0.01)}"
end

def show_sale(product)
  if product.sale == 1
    "not on sale"
  else
    "#{100 - (product.sale * 100).to_i}\% off .. Sale Price: #{money(product.sale * product.price)}" 
  end
end

def show_product(product)
  puts "#{product.category}"
  puts "(##{product.serial_number}) #{product.name} - Qty: #{product.quantity}"
  puts "          Cost: #{money(product.cost)} ... RegPrice: #{money(product.price)}"
  puts "          Expires: #{product.expiry.strftime("%m/%d/%y")}"
  puts "          #{show_sale(product)}"
  puts
end


def main_menu
  system "clear"
  puts "Welcome to Tom-Mart!"
  puts
  puts "Make your choice:"
  puts "-----------------"
  puts "1. View All Products"
  puts "2. View By Category"
  puts "3. Lookup Item By Serial Number"
  puts "4. Check Soon to Expire"

  choice = gets.chomp

  case choice
  when "1"
    view_all
  when "2"
    view_category
  when "3"
    view_serial
  when "4"
    view_expiry
  else
    "Invalid try again"
    main_menu
  end
end

def view_all
  system "clear"
  @all_products.each do |product|
    show_product(product)
  end

  puts "1. Select Item by serial number"
  puts "2. Go back"

  choice = gets.chomp

  case choice
  when "1"
    view_serial
  when "2"
    main_menu
  else
    "Invalid try again"
    main_menu
  end
end

def view_category
  system "clear"
  puts "Choose a category:"
  possible_categories = []
  @categories.each_with_index do |category, i|
    puts "#{i + 1}. #{category}"
    possible_categories.push((i + 1).to_s)
  end

  choice = gets.chomp
  unless possible_categories.include? choice
    puts "its not here"
    view_category
  end

  selected_category = @categories[choice.to_i - 1]

  @all_products.each do |product|
    if selected_category == product.category
      show_product(product)
    end
  end

  puts "1. Select Item by serial number"
  puts "2. Put entire category on sale" 
  puts "3. Go back"

  choice = gets.chomp

  case choice
  when "1"
    view_serial
  when "2"
    puts "Enter percentage off (eg, 0.5 = 50%)"
    puts "enter 0 to return to regular price"
    p selected_category
    sale_amt = 1 - gets.chomp.to_f
    
    @all_products.each do |product|
      if product.category == selected_category
        product.sale = sale_amt
      end
    end
    view_category
  when "3"
    main_menu
  else
    "Invalid try again"
    main_menu
  end
end

def view_serial
  print "Enter #: "
  serial = gets.chomp.to_i

  selected_product = nil
  @all_products.each do |product|
    if product.serial_number == serial
      selected_product = product
      # product_exists = true
    end
  end

  if selected_product
    product_actions(selected_product)
  else
    puts "no such number"
    view_serial
  end
end

def product_actions(product)
  system "clear"
  show_product(product)

  puts "What would you like to do?"
  puts "--------------------------"
  puts "1. Add Quantity"
  puts "2. Change Price"
  puts "3. Put Item on Sale"
  puts "4. Show total cost"
  puts "5. Show potential Revenue"
  puts "6. Show potential Profit"
  puts "7. go back"

  choice = gets.chomp

  case choice
  when "1"
    puts "How many would you like to add?"
    product.add_inv(gets.chomp.to_i)
  when "2"
    puts "what would you like the new price to be?"
    product.price = gets.chomp.to_i
  when "3"
    puts "Enter percentage off (eg, 0.5 = 50%)"
    puts "enter 0 to return to regular price"
    sale_amt = 1 - gets.chomp.to_f
    product.sale = sale_amt
  when "4"
    puts
    puts "#{product.name} total cost:"
    puts money(product.cost * product.quantity)
    puts "press enter to continue"
    gets
  when "5"
    puts
    puts "#{product.name} potential revenue:"
    puts money(product.price * product.sale * product.quantity)
    puts "press enter to continue"
    gets
  when "6"
    puts
    puts "#{product.name} potential profit:"
    puts money(((product.price * product.sale) - product.cost) * (product.quantity))
    puts "press enter to continue"
    gets
  when "7"
    main_menu
  end
  product_actions(product)
end

def view_expiry
  puts "Check items expiring in how many days?"
  days = gets.chomp.to_i
  later = DateTime.now.next_day(days)

  any = false
  @all_products.sort {|a,b| a.expiry <=> b.expiry}.each do |product|
    
    if product.expiry < later
      show_product(product)
      any = true
    end
  end

  unless any
    puts "No items are expiring in #{days} days."
  end
  
  puts "check again? y/n"
  choice = gets.chomp.downcase

  choice == "y" ? view_expiry : main_menu

end

main_menu