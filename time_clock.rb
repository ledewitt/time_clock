require "yaml"
require "yaml/store"
require "sinatra"
require "sinatra/reloader" if development?

enable :sessions

users = YAML::Store.new("db/user.yml")
db = { }

# users.transaction do
#   users["luke@dewittsoft.com"] = [ ]
#   users["james@graysoftinc.com"] = [ ]
# end

get('/') {
  if params[:email]
    erb :home, locals: { user:     (params[:email]),
                         time_now: Time.now }
  else
    redirect '/login'
  end
}

post('/') {
  (db[session[:email]][params[:project]] ||= [ ]) << [Time.now]

  # Thoughts:  I want the "clock in" and "clock out" done from this post
  # action.
  # On the home page the project text field and start button are
  # displayed if I have yet to "clock in", once "clocked in" display
  # a finsh button only which when pressed will log the check out.

  # CODE for the YAML interface might come in handy after objects are done.  
  # users.transaction do
  #   users[session[:email]] << params[:project].to_s << Time.now
  # end
  # 
  # users.transaction(true) do
  #   if users[session[:email]]
  #     p "My project is: #{users[session[:email]]}. 
  #        My start time is: #{Time.now}"
  #   end
  # end
}

get('/join') {
  erb :join
}

post('/join') {
  # Be a good check to see if the address looks like email.
  
  # session[:email] = params[:email]
  
  users.transaction do
    users["#{session[:email]}"] = [ ]
  end
  
  redirect "/?email=#{session[:email]}"
}

get('/login') {
  db[session[:email]] = { }
  
  # Delete data flow checking.
  p db
  
  erb :login
}

post('/login') {
  # Needs to check to see if user is in the database.
  # If so redirect to the home page with the email added
  # to the end of the address.
  
  session[:email] = params[:email]
  
  users.transaction(true) do
    if users.roots.include? (session[:email].to_s)
      redirect "/?email=#{session[:email]}"
    else
      redirect "/login"
    end
  end
}