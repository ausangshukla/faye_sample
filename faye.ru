require 'faye'
require 'faye/redis'

Faye::WebSocket.load_adapter 'thin'
require File.expand_path('../config/initializers/faye.rb', __FILE__)


class ServerAuth
  def incoming(message, callback)
    if message['channel'] !~ %r{^/meta/}
      if message['ext']['auth_token'] != FAYE_TOKEN
        message['error'] = 'Invalid authentication token.'
      end
    end
    callback.call(message)
  end
end

Faye::Logging.log_level = :debug
Faye.logger = lambda {|m| puts m}

faye_server  = Faye::RackAdapter.new(
  :mount   => '/faye',
  :timeout => 45
)

faye_server.add_extension(ServerAuth.new)
run faye_server