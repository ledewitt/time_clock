require "yaml/store"
require "sinatra"
require "sinatra/reloader" if development?

require_relative "lib/time_clock/time_sheet"

enable :sessions

helpers do
  def db
    @db ||= YAML::Store.new("db/time_clock.yml")
  end
  
  def timesheet
    @timesheet ||= TimeClock::TimeSheet.new
  end

  def clocked_in?
    db.transaction(true) do
      db[session[:email]].values.flatten(1).any? { |pair| pair.size == 1 }
    end
  end
end

get('/') {
  if session[:email]
    erb :home, locals: {         week: (params[:week] || timesheet
                                                         .current_week).to_i,
                         current_week: timesheet.current_week.to_i }
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
  session[:email] = params[:email]

  redirect "/"
}
