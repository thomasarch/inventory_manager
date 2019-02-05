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
  def view_all(params)
    params['data'] = @product_list
    @view.draw_screen(params)
    choice = @validate.input(params)
    action = params['menu']['options'][choice][1]
    params = { 'action' => action }
    router(params)
  end

  def choose_category(params)
    params['menu']['options'] = @categories
    @view.draw_screen(params)
    category = @categories[@validate.input(params)][1]
    params['data'] = @product_list.select { |item| item.category == category }
    params['action'] = 'show_category'
    router(params)
  end

  def show_category(params)
    @view.draw_screen(params)
    choice = @validate.input(params)
    action = params['menu']['options'][choice][1]
    params['action'] = action
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

  def show_product(params)
    @view.draw_screen(params)
    choice = @validate.input(params)
    action = params['menu']['options'][choice][1]
    params['action'] = action
    router(params)
  end

  def add_qty(params)
    @view.draw_screen(params)
    choice = @validate.input(params)
    params['data'][0].add_qty(choice)
    params['action'] = 'show_product'
    router(params)
  end

  def change_price(params)
    @view.draw_screen(params)
    choice = @validate.input(params)
    params['data'][0].change_price(choice)
    params['action'] = 'show_product'
    router(params)
  end

  def put_on_sale(params)
    @view.draw_screen(params)
    choice = @validate.input(params)
    params['data'][0].put_on_sale(choice)
    params['action'] = 'show_product'
    router(params)
  end

  def show_total_cost(params)
    params['data'][0].show_total_cost
    params['action'] = 'show_product'
    router(params)
  end

  def show_potential_revenue(params)
    params['data'][0].show_potential_revenue
    params['action'] = 'show_product'
    router(params)
  end

  def show_potential_profit(params)
    params['data'][0].show_potential_profit
    params['action'] = 'show_product'
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
