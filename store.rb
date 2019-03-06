require_relative 'controller'

@controller = Controller.new

def controller_action(params)
  @controller.router(params)
end

controller_action('action' => 'main')
