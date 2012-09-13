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

post('/join') {
  # Append the user to the database
  
  users.transaction do
    users[3] = {email: "test@test.com"}
  end
}

get('/login') {
  erb :login
}

post('login') {
  # Needs to check to see if user is in the database.
  # If so redirect to the home page with the email added
  # to the end of the address.
}