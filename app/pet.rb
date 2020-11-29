require "erb"
require './app/lib/logic'

class Pet
  include Logic

  def self.call(env)
    new(env).response.finish
  end

  def initialize(env)
    @req = Rack::Request.new(env)
    @stomach = 4
    @hp = 5
    @intelect  = 2
    @interest  = 3
    @purity = 3
    @sleepiness = 0
    $time = 1

  end

  def response
    case @req.path
    when '/'
      Rack::Response.new(render("form.html.erb"))

    when '/initialize'
      Rack::Response.new do |response|
        response.set_cookie('hp', @hp)
        response.set_cookie('stomach', @stomach)
        response.set_cookie('sleep', @sleepiness)
        response.set_cookie('intelect', @intelect)
        response.set_cookie('interest', @interest)
        response.set_cookie('purity', @purity)
        response.set_cookie('name', @req.params['name'])
        response.set_cookie('time',$time)
        response.set_cookie('day_period', 'morning')
        response.redirect('/start')

      end
    when '/away'
      Rack::Response.new('111', 404)
      Rack::Response.new(render("away.html.erb"))

    when '/lost'
      Rack::Response.new('111', 404)
      Rack::Response.new(render("lost.html.erb"))

    when '/exit'
      Rack::Response.new('Game Over', 404)
      Rack::Response.new(render("over.html.erb"))

    when '/help'
      Rack::Response.new(render("help.html.erb"))

    when '/start'
      if get("hp") <= 0
        Rack::Response.new('Game Over', 404)
        Rack::Response.new(render("over.html.erb"))
      elsif $walk_result == "lost"
        $walk_result = 0
        Rack::Response.new(render("lost.html.erb"))
      elsif $walk_result == "away"
        $walk_result = 0
        Rack::Response.new(render("away.html.erb"))
      else
        if get("time") < 3
          Rack::Response.new(render("index.html.erb"))
        else
          Rack::Response.new(render("Night_index.html.erb"))
         end
      end

    when '/change'

      return Logic.change_params(@req, 'hp') if @req.params['hp']
      return Logic.change_params(@req, 'stomach')   if @req.params['stomach']
      return Logic.change_params(@req, 'sleeping')  if @req.params['sleeping']
      return Logic.change_params(@req, 'train') if @req.params['train']
      return Logic.change_params(@req, 'interest')  if @req.params['interest']
      return Logic.change_params(@req, 'walk') if @req.params['walk']
      return Logic.change_params(@req, 'looking') if @req.params['looking']
      return Logic.change_params(@req, 'cleaning') if @req.params['cleaning']

    else
      Rack::Response.new('Not Found', 404)
    end
  end

  def render(template)
    path = File.expand_path("../views/#{template}", __FILE__)
    ERB.new(File.read(path)).result(binding)
  end

  def name
    name = @req.cookies['name'].delete(' ')
    name.empty? ? 'Dog' : @req.cookies['name']
  end

  def get(attr)
    @req.cookies["#{attr}"].to_i
  end
  def get_str(attr)
    @req.cookies["#{attr}"].to_s
  end
end
