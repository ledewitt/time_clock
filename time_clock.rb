require "yaml/store"
require "sinatra"
require "sinatra/reloader" if development?

require_relative "lib/time_clock/unit_of_work"
require_relative "lib/time_clock/time_sheet"

enable :sessions

helpers do
  def timesheet
    TimeClock::TimeSheet.new(session[:email])
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
  if timesheet.clocked_in?(session[:email])
    timesheet.clock_out(session[:email])
  else
    timesheet.clock_in(session[:email], params[:project])
  end
  redirect "/"
}

get('/join') {
  erb :join
}

post('/join') {
  session[:email] = params[:email]
  timesheet.join(session[:email])
  redirect "/"
}

get('/login') {
  erb :login
}

post('/login') {
  session[:email] = params[:email]

  redirect "/"
}
