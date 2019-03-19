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
  end

  def initialize
    @view = Viewer.new
    @validate = Validator.new
    import_products
    @menu_list = JSON.parse(File.read('menus.json'))
    @data = nil
  end

  # action methods
  # view stuff
  def viewer(params)
    @view.draw_screen(params)
    choice = @validate.input(params)
    action = params['menu']['options'][choice][1]
    params['action'] = action
  end

  def view_all(params)
    params['data'] = @product_list
    viewer(params)
    router(params)
  end

  def show_category(params)
    viewer(params)
    router(params)
  end

  def show_product(params)
    viewer(params)
    unless params['action'] == 'main'
      params['object_method'] = params['action']
      params['action'] = 'call_method_on_product'
    end
    router(params)
  end

  # call method on product
  def call_method_on_product(params)
    object_method = params['object_method']
    params['menu'] = params['menu'][object_method]
    params['action'] = object_method
    if params['menu'].nil?
      params['data'][0].send(params['object_method'])
    else
      @view.draw_screen(params)
      choice = @validate.input(params)
      params['data'][0].send(params['object_method'], choice)
    end
    params['action'] = 'show_product'
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

  def create_new_product(params)
    product_attributes = @validate.input(params)
    new_product = Product.new(product_attributes)
    @product_list.push(new_product)
    params['data'] = [new_product]
    params['action'] = 'show_product'
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
    send(action, params)
  end
end
