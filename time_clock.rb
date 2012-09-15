require "yaml"
require "yaml/store"
require "sinatra"
require "sinatra/reloader" if development?

enable :sessions

users = YAML::Store.new("db/user.yml")

# users.transaction do
#   users["luke@dewittsoft.com"] = [ ]
#   users["james@graysoftinc.com"] = [ ]
# end

get('/') {
  time_now = Time.now
  
  if params[:email]
    erb :home, locals: { user:     (params[:email]),
                         time_now: time_now }
  else
    redirect '/login'
  end
}

get('/join') {
  erb :join
}

post('/join') {
  # Be a good check to see if the address looks like email.
  
  session[:email] = params[:email]
  
  users.transaction do
    users["#{sessions[:email]}"] = [ ]
  end
  
  redirect "/?email=#{sessions[:email]}"
}

get('/login') {
  erb :login
}

post('/login') {
  # Needs to check to see if user is in the database.
  # If so redirect to the home page with the email added
  # to the end of the address.
  
  session[:email] = params[:email]
  
  users.transaction(true) do
    if users.roots.include? (params[:email].to_s)
      redirect "/?email=#{params[:email]}"
    else
      redirect "/login"
    end
  end
}