# prompts user for response and selects appriopiate actions
class Input
  def standard_menu(options, valid = false)
    print 'enter a number: '
    until valid == true
      choice = gets.chomp.to_i - 1
      if choice >= 0 && choice < options.count
        valid = true
      else
        print 'invalid input. try again: '
      end
    end
    [options[choice][2], options[choice][1]]
  end

  def main(params)
    standard_menu(params)
  end

  def view_all(params)
    standard_menu(params)
  end

  def show_item(params)
    standard_menu(params)
  end

  def add_qty
    print "how many would you like to add? "
    gets.chomp.to_i
    p @data
  end

  def fetch_serial(params, valid = false)
    list = params
    until valid == true
      print "enter a serial number (type 'back' to go back): "
      choice = gets.chomp
      if choice == 'back'
        valid = true
        return 'main'
      else
        choice = choice.to_i
        product = list.find { |item| item.serial_number == choice }
        if product.nil?
          puts 'item not found'
        else
          valid = true
          return ['screen', 'show_item', product]
        end
      end
    end
  end
end
