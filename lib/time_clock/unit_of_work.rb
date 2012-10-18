module TimeClock
  class UnitOfWork
    PRETTY_TIME_FORMAT = "%b %d %I:%M %P"

    def initialize(in_time, out_time)
      @in_time  = in_time
      @out_time = out_time
    end

    attr_reader  :in_time,   :out_time
    alias_method :finished?, :out_time

    def during?(week)
      in_time.strftime("%W").to_i == week
    end

    def formatted_in_time
      in_time.strftime(PRETTY_TIME_FORMAT)
    end

    def formatted_out_time
      out_time.strftime(PRETTY_TIME_FORMAT)
    end

    def elapsed_time
      Time.at(out_time - in_time).gmtime.strftime("%R")
    end
  end
end
