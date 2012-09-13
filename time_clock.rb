require "yaml"
require "sinatra"
require "sinatra/reloader" if development?

get('/') {
  time_now = Time.now
  
  if params[:name]
    #check to see if it exists in database as well
  else
    redirect '/login'
  end
    
  erb :home, locals: { time_now: time_now,
                       name:     (params[:name]) }
}

get('/join') {
  erb :join
}

get('/login') {
  erb :login
}