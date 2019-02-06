require 'json'
require 'date'
require_relative 'product'
require_relative 'viewer'
require_relative 'validator'

# defines the controller class
class Controller
  def import_products
    parsed_products = JSON.parse(File.read('products.json'))
    @product_list = parsed_products['products'].map { |item| Product.new(item) }
    @categories = @product_list.collect(&:category).uniq
    @categories.map! { |c| [c, c] }
    @data = nil
  end

  def initialize
    @view = Viewer.new
    @validate = Validator.new
    import_products
    @menu_list = JSON.parse(File.read('menus.json'))
  end

  # action methods
  # view stuff
  def viewer(params)
    @view.draw_screen(params)
    choice = @validate.input(params)
    action = params['menu']['options'][choice][1]
    params['action'] = action
    router(params)
  end

  def view_all(params)
    params['data'] = @product_list
    viewer(params)
  end

  def show_category(params)
    viewer(params)
  end

  def show_product(params)
    viewer(params)
  end

  # call method on product
  def call_method_on_product(params, input = nil)
    if input.nil?
      params['data'][0].public_send(params['action'])
    else
      @view.draw_screen(params)
      choice = @validate.input(params)
      params['data'][0].public_send(params['action'], choice)
    end
    params['action'] = 'show_product'
    router(params)
  end

  def show_total_cost(params)
    call_method_on_product(params)
  end

  def show_potential_revenue(params)
    call_method_on_product(params)
  end

  def show_potential_profit(params)
    call_method_on_product(params)
  end

  def add_qty(params)
    call_method_on_product(params, 'yes')
  end

  def change_price(params)
    call_method_on_product(params, 'yes')
  end

  def put_on_sale(params)
    call_method_on_product(params, 'yes')
  end
  # end call method on product

  def choose_category(params)
    params['menu']['options'] = @categories
    @view.draw_screen(params)
    category = @categories[@validate.input(params)][1]
    params['data'] = @product_list.select { |item| item.category == category }
    params['action'] = 'show_category'
    router(params)
  end

  def discount_category(params)
    choice = @validate.input(params)
    params['data'].each { |item| item.put_on_sale(choice) }
    params['action'] = 'show_category'
    router(params)
  end

  def lookup_product(params)
    params['data'] = @product_list
    product = @validate.input(params)
    if product == 'back'
      params['action'] = 'main'
    else
      params = { 'data' => [product], 'action' => 'show_product' }
    end
    router(params)
  end

  def choose_expiry(params)
    params['data'] = @product_list
    days = @validate.input(params)
    now = DateTime.now
    exp = params['data'].select { |item| item.expiry - days < now }
    exp ? exp.sort_by!(&:expiry) : ''
    params['data'] = exp
    params['action'] = 'show_category'
    router(params)
  end

  def main(params)
    params['data'] = nil
    @view.draw_screen(params)
    choice = @validate.input(params)
    action = params['menu']['options'][choice][1]
    params = { 'action' => action }
    router(params)
  end

  def router(params)
    action = params['action']
    params['menu'] = @menu_list[action]
    public_send(action, params)
  end
end
