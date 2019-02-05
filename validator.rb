# handles different validation types
class Validator
  def input(params)
    input = params['menu']['input']
    print params['menu']['input'][1]
    choice = gets.chomp
    choice == 'back' ? 'back' : public_send(input[0], params, choice)
  end

  def menu(params, choice)
    choice = choice.to_i - 1
    if choice >= 0 && choice < params['menu']['options'].count
      choice
    else
      puts params['menu']['input'][2]
      input(params)
    end
  end

  def item_lookup(params, choice)
    choice = choice.to_i
    product = params['data'].find { |item| item.serial_number == choice }
    if product
      product
    else
      puts params['menu']['input'][2]
      input(params)
    end
  end

  def integer(params, choice)
    if choice.to_i > 0
      choice.to_i
    else
      puts params['menu']['input'][2]
      input(params)
    end
  end
end
