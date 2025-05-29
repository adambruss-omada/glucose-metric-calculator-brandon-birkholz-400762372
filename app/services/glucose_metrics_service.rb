class GlucoseMetricsService
  def initialize(member, time_frame)
    @member = member
    @time_frame = time_frame
  end

  def calculate_metrics
    {
      average_glucose: calculate_average_glucose,
      time_above_range: calculate_time_above_range,
      time_below_range: calculate_time_below_range
    }
  end

  private

  def calculate_average_glucose
    readings = glucose_readings
    return 0 if readings.empty?

    (readings.sum(&:value).to_f / readings.count).round(2)
  end

  def calculate_time_above_range
    readings = glucose_readings
    return 0 if readings.empty?

    above_range = readings.count { |reading| reading.value > 180 }
    (above_range.to_f / readings.count * 100).round(2)
  end

  def calculate_time_below_range
    readings = glucose_readings
    return 0 if readings.empty?

    below_range = readings.count { |reading| reading.value < 70 }
    (below_range.to_f / readings.count * 100).round(2)
  end

  def glucose_readings
    @glucose_readings ||= begin
      case @time_frame
      when :week
        @member.glucose_levels.where(
          tested_at: 7.days.ago.beginning_of_day..Time.current.end_of_day
        )
      when :month
        @member.glucose_levels.where(
          tested_at: Time.current.beginning_of_month..Time.current.end_of_month
        )
      else
        raise ArgumentError, "Invalid time frame: #{@time_frame}"
      end
    end
  end
end
