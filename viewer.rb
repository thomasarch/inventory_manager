# handles drawing various views
class Viewer
  def format_money(num)
    format('$%.2f', (num * 0.01))
  end

  def format_product(item)
    puts item.category.to_s
    puts "(##{item.serial_number}) #{item.name} - Qty: #{item.quantity}"
    puts "          Cost: #{format_money(item.cost)}"
    puts "          RegPrice: #{format_money(item.price)}"
    puts "          Expires: #{item.expiry.strftime('%m/%d/%y')}"
    # puts "          #{show_sale(item)}"
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
    section[1].nil? ? '' : public_send(section[0], section[1])
  end

  def draw_screen(params)
    params.each { |item| draw_section(item) }
  end
end
