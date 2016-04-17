require 'time'

class Time
  def to_ms
    (self.to_f * 1000.0).to_i
  end
  
  def time_until(future_date)
    future_date.to_ms - self.to_ms
  end
end