require "yaml"
require "sinatra"
require "sinatra/reloader" if development?

get('/') {
  time_now = Time.now
  
  erb :home, locals: { time_now: time_now }
}