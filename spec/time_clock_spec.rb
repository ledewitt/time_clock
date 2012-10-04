# TBD: Not sure if I need the idea of a clock object anymore
require 'time_clock/clock'
require 'time_clock/time_sheet'

describe "time_sheet" do
  before do
    @timeclock = TimeClock::TimeSheet.new
  end
  
  it "should create a time sheet" do
    @timeclock.should be_an_instance_of TimeClock::TimeSheet
  end
end