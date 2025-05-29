class GlucoseMetricsService
  def initialize(member, time_frame)
    @member = member
    @time_frame = time_frame
  end

  def calculate_metrics
    current_metrics = calculate_current_metrics
    previous_metrics = calculate_previous_metrics

    {
      average_glucose: current_metrics[:average_glucose],
      time_above_range: current_metrics[:time_above_range],
      time_below_range: current_metrics[:time_below_range],
      average_glucose_change: calculate_change(current_metrics[:average_glucose], previous_metrics[:average_glucose]),
      time_above_range_change: calculate_change(current_metrics[:time_above_range], previous_metrics[:time_above_range]),
      time_below_range_change: calculate_change(current_metrics[:time_below_range], previous_metrics[:time_below_range])
    }
  end

  private

  def calculate_current_metrics
    {
      average_glucose: calculate_average_glucose,
      time_above_range: calculate_time_above_range,
      time_below_range: calculate_time_below_range
    }
  end

  def calculate_previous_metrics
    {
      average_glucose: calculate_average_glucose(previous_period_start, previous_period_end),
      time_above_range: calculate_time_above_range(previous_period_start, previous_period_end),
      time_below_range: calculate_time_below_range(previous_period_start, previous_period_end)
    }
  end

  def calculate_average_glucose(start_time = nil, end_time = nil)
    readings = glucose_readings(start_time, end_time)
    return 0 if readings.empty?

    (readings.sum(&:value).to_f / readings.count).round(2)
  end

  def calculate_time_above_range(start_time = nil, end_time = nil)
    readings = glucose_readings(start_time, end_time)
    return 0 if readings.empty?

    above_range = readings.count { |reading| reading.value > 180 }
    (above_range.to_f / readings.count * 100).round(2)
  end

  def calculate_time_below_range(start_time = nil, end_time = nil)
    readings = glucose_readings(start_time, end_time)
    return 0 if readings.empty?

    below_range = readings.count { |reading| reading.value < 70 }
    (below_range.to_f / readings.count * 100).round(2)
  end

  def glucose_readings(start_time = nil, end_time = nil)
    start_time ||= current_period_start
    end_time ||= current_period_end

    @member.glucose_levels.where(tested_at: start_time..end_time)
  end

  def calculate_change(current_value, previous_value)
    return 0 if previous_value.zero?
    ((current_value - previous_value) / previous_value * 100).round(2)
  end

  def current_period_start
    case @time_frame
    when :week
      7.days.ago.beginning_of_day
    when :month
      Time.current.beginning_of_month
    else
      raise ArgumentError, "Invalid time frame: #{@time_frame}"
    end
  end

  def current_period_end
    case @time_frame
    when :week
      Time.current.end_of_day
    when :month
      Time.current.end_of_month
    else
      raise ArgumentError, "Invalid time frame: #{@time_frame}"
    end
  end

  def previous_period_start
    case @time_frame
    when :week
      14.days.ago.beginning_of_day
    when :month
      1.month.ago.beginning_of_month
    else
      raise ArgumentError, "Invalid time frame: #{@time_frame}"
    end
  end

  def previous_period_end
    case @time_frame
    when :week
      7.days.ago.end_of_day
    when :month
      1.month.ago.end_of_month
    else
      raise ArgumentError, "Invalid time frame: #{@time_frame}"
    end
  end
end
