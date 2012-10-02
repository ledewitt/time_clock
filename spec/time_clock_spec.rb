require 'time_clock/clock'
require 'time_clock/time_sheet'

describe "timeclock" do
  before do
    @timeclock = Time_Clock::Clock.new
  end
  
  it "should create a time clock" do
    @timeclock.should be_an_instance_of Time_Clock::Clock
  end
end