require_relative 'controller'

@controller = Controller.new

def controller_action(params)
  response = @controller.public_send('router', params)
  # controller_action(router, params)
end

controller_action({ 'action' => 'main' })
# controller_action('screen', 'view_all')
