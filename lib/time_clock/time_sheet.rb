module TimeClock
  class TimeSheet
    
    def initialize
      @timesheet = YAML::Store.new("db/time_clock.yml")
    end
    
    def clocked_in?
      @timesheet.transaction(true) do
        @timesheet[session[:email]].values
                                   .flatten(1).any? { |pair| pair.size == 1 }
      end
    end    
    
    def current_week
      Time.now.strftime("%W")
    end
  end
end

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