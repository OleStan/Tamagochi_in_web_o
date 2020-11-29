require 'rack'
my_rack_proc = lambda { |env| [200, {"Content-Type" => "text/div"}, ["Hello. AAAAAAAAThe tiiiiiiiiiiiiiiiiiiiiime is #{Time.now}"]] }
puts my_rack_proc.call({})
puts Rack::Handler.constants
Rack::Handler::WEBrick
Rack::Handler::WEBrick.run my_rack_proc