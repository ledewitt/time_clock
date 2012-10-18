module TimeClock
  class TimeSheet
    def initialize(user)
      @timesheet = YAML::Store.new("db/time_clock.yml")
      @user      = user
    end

    attr_reader :timesheet, :user

    def report(project)
      user_entries(true) { |entries|
        entries[project].map { |in_time, out_time|
          UnitOfWork.new(in_time, out_time)
        }
      }
    end

    def projects
      user_entries(true) { |entries| entries.keys }
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

    def user_entries(read_only = false)
      timesheet.transaction do
        yield timesheet[user]
      end
    end

    def current_week
      Time.now.strftime("%W")
    end
  end
end