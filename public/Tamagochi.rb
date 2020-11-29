# frozen_string_literal: true
require "erb"
require 'yaml'
require 'rack'
require './app/lib/logic'



# start game--------------------------------------
class Pet
  include Logic
  def self.call(env)
    new(env).response.finish
  end

  def initialize(env)
    @req = Rack::Request.new(env)
    @stomach = 50
    @hp = 50
    @intelect = 50
    @interest = 20
    @drink  = 0
    $NEEDS  = %w[hp stomach intelect interest]
  end

  def response
    case @req.path
    when '/'
      Rack::Response.new(render("form.html.erb"))

    when '/initialize'
      Rack::Response.new do |response|
        response.set_cookie('hp', @hp)
        response.set_cookie('stomach', @stomach)
        response.set_cookie('intelect', @intelect)
        response.set_cookie('interest', @interest)
        response.set_cookie('drink', @drink)
        response.set_cookie('name', @req.params['name'])
        response.redirect('/start')
      end

    when '/exit'
      Rack::Response.new('Game Over', 404)
      Rack::Response.new(render("over.html.erb"))

    when '/meditation'
      return Logic.meditation_params(@req, 'drink') if @req.params['drink']
      if get("drink") >= 100
        Rack::Response.new('Game complete', 404)
        Rack::Response.new(render("complete.html.erb"))
      else
        Rack::Response.new(render("help.html.erb"))
      end

    when '/start'
      if get("hp") <= 0 || get("stomach") <= 0 || get("intelect") <= 0 || get("interest") <= 0
        Rack::Response.new('Game Over', 404)
        Rack::Response.new(render("over.html.erb"))
      else
        Rack::Response.new(render("index.html.erb"))
      end

    when '/change'
      return Logic.change_params(@req, 'hp') if @req.params['hp']
      return Logic.change_params(@req, 'stomach')   if @req.params['stomach']
      return Logic.change_params(@req, 'intelect')  if @req.params['intelect']
      return Logic.change_params(@req, 'interest')  if @req.params['interest']
      return Logic.change_params(@req, 'drink') if @req.params['drink']
    else
      Rack::Response.new('Not Found', 404)
    end
  end
end
