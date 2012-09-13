require "yaml"
require "yaml/store"
require "sinatra"
require "sinatra/reloader" if development?

users = YAML::Store.new("yaml/db.yml")

users.transaction do
  users[1] = {email: "luke@dewittsoft.com"}
  users[2] = {email: "james@graysoftinc.com"}
end

get('/') {
  time_now = Time.now
  
  if params[:email]
    #check to see if it exists in database as well
  else
    redirect '/login'
  end
    
  erb :home, locals: { time_now: time_now,
                       email:     (params[:email]) }
}

get('/join') {
  erb :join
}

get('/login') {
  erb :login
}