module TimeClock
  class TimeSheet

    def initialize
      @timesheet = YAML::Store.new("db/time_clock.yml")
    end
    
    attr_reader :timesheet
    
    def report(user, project)
      timesheet.transaction do
        timesheet[user][project]
      end
    end
    
    def projects(user)
      timesheet.transaction do
        timesheet[user].keys
      end
    end

    def clock_out(user)
      timesheet.transaction do
        timesheet[user].values
                       .flatten(1)
                       .find { |pair| pair.size == 1 } << Time.now
      end
    end

    def clock_in(user, project)
      timesheet.transaction do
        (timesheet[user][project] ||= [ ]) << [Time.now]
      end
    end

    def clocked_in?(user)
      timesheet.transaction(true) do
        timesheet[user].values
                        .flatten(1).any? { |pair| pair.size == 1 }
      end
    end
    
    def join(user)
      # TODO: Check to see if the address looks like email.
      timesheet.transaction do
        timesheet[user] = { }
      end
    end
    
    def current_week
      Time.now.strftime("%W")
    end
  end
end