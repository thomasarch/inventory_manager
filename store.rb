require_relative 'controller'

@controller = Controller.new

def controller_action(to_what, action, params = nil)
  p response = @controller.public_send(to_what, action, params)
  controller_action(response[0], response[1], response[2])
end

controller_action('screen', 'main')
# controller_action('screen', 'view_all')
