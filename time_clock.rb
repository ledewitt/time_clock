require "yaml"
require "yaml/store"
require "sinatra"
require "sinatra/reloader" if development?

enable :sessions

users = YAML::Store.new("yaml/db.yml")

# users.transaction do
#   users["luke@dewittsoft.com"] = [ ]
#   users["james@graysoftinc.com"] = [ ]
# end

get('/') {
  time_now = Time.now
  
  if params[:email]
    erb :home, locals: { time_now: time_now,
                         email:     (params[:email]) }
  else
    redirect '/login'
  end
}

get('/join') {
  erb :join
}

post('/join') {
  # Append the user to the database
  
  # Add to the session
  
  users.transaction do
    users["#{params[:email]}"] = [ ]
  end
  
  redirect "/?email=#{params[:email]}"
}

get('/login') {
  erb :login
}

post('/login') {
  # Needs to check to see if user is in the database.
  # If so redirect to the home page with the email added
  # to the end of the address.
  
  # Add to sessions
  
  users.transaction(true) do
    
  end
}