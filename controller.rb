require 'json'
require_relative 'product'
require_relative 'viewer'
require_relative 'input'

# defines the controller class
class Controller
  def import_products
    parsed_products = JSON.parse(File.read('products.json'))
    @product_list = parsed_products['products'].map { |item| Product.new(item) }
    @categories = @product_list.collect(&:category).uniq
    @data = nil
  end

  def initialize
    @view = Viewer.new
    @input = Input.new
    import_products
    @menu_list = JSON.parse(File.read('menus.json'))
  end

  def view_all
    @product_list
  end

  def show_item; end

  def main; end

  def fetch_data(action, params = nil)
    params.nil? ? public_send(action) : public_send(action, params)
  end

  def create_screen(menu, data = nil)
    # system 'clear'
    screen = {}
    screen['heading'] = menu['heading']
    screen['data'] = @data
    screen['options'] = menu['options']
    screen
  end

  def screen(action, params = nil)
    menu = @menu_list[action]
    params.nil? ? @data = fetch_data(action, params) : @data = [params]
    @view.draw_screen(create_screen(menu))
    input(action, menu['options'])
  end

  def input(action, params = nil)
    params.nil? ? params = @data : ''
    @input.public_send(action, params)
  end

  def object(action, params = nil)
    response = @input.public_send(action)
    @data[0].public_send(action, response)
  end
end
