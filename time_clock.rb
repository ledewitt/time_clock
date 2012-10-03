require "yaml/store"
require "sinatra"
require "sinatra/reloader" if development?

enable :sessions

helpers do
  def db
    @db ||= YAML::Store.new("db/time_clock.yml")
  end

  def clocked_in?
    db.transaction(true) do
      db[session[:email]].values.flatten(1).any? { |pair| pair.size == 1 }
    end
  end
end

get('/') {
  current_week = Time.now.strftime("%W")
    
  if session[:email]
    erb :home, locals: {         week: (params[:week] || current_week).to_i,
                         current_week: current_week.to_i }
  else
    redirect '/login'
  end
}

post('/') {
  if clocked_in?
    db.transaction do
      db[session[:email]].values
                         .flatten(1)
                         .find { |pair| pair.size == 1 } << Time.now
    end
  else
    db.transaction do
      (db[session[:email]][params[:project]] ||= [ ]) << [Time.now]
    end
  end

  redirect "/"

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
  db.transaction do
    db[params[:email]] = { }
  end
  session[:email] = params[:email]

  redirect "/"
}

get('/login') {
  erb :login
}

post('/login') {
  # Needs to check to see if user is in the database.
  # If so redirect to the home page with the email added
  # to the end of the address.

  session[:email] = params[:email]

  redirect "/"
}
