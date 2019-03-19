require 'json'

# handles drawing various views
class Viewer
  def format_money(num)
    format('$%.2f', (num * 0.01))
  end

  def show_sale(product)
    if product.sale == 1
      'not on sale'
    else
      "#{product.show_sale} off .. Sale Price: #{product.sale_price}"
    end
  end

  def format_product(item)
    puts item.category.to_s
    puts "(##{item.serial_number}) #{item.name} - Qty: #{item.quantity}"
    puts "          Cost: #{item.cost}"
    puts "          RegPrice: #{item.price}"
    puts "          Expires: #{item.expiry}"
    puts "          #{show_sale(item)}"
    puts
  end

  def heading(lines)
    lines.each { |line| puts line }
  end

  def data(products)
    products.each { |product| format_product(product) }
  end

  def options(lines)
    lines.each_with_index { |line, i| puts "#{i + 1}. #{line[0]}" }
  end

  def draw_section(section)
    section[1].nil? ? '' : send(section[0], section[1])
  end

  def draw_screen(params)
    system 'clear'
    menu = params['menu']
    draw_section(['heading', menu['heading']])
    draw_section(['data', params['data']])
    draw_section(['options', menu['options']])
  end
end
