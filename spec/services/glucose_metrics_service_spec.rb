require 'rails_helper'

RSpec.describe GlucoseMetricsService do
  let(:member) { create(:member) }
  let(:service) { described_class.new(member, time_frame) }

  describe '#calculate_metrics' do
    context 'with weekly time frame' do
      let(:time_frame) { :week }

      context 'when there are no readings' do
        it 'returns zero values for all metrics and changes' do
          metrics = service.calculate_metrics

          expect(metrics).to eq({
            average_glucose: 0,
            time_above_range: 0,
            time_below_range: 0,
            average_glucose_change: 0,
            time_above_range_change: 0,
            time_below_range_change: 0
          })
        end
      end

      context 'when there are readings' do
        before do
          # Current week readings
          create(:glucose_level, member: member, value: 150, tested_at: 1.day.ago)
          create(:glucose_level, member: member, value: 200, tested_at: 2.days.ago) # above range
          create(:glucose_level, member: member, value: 60, tested_at: 3.days.ago)  # below range
          create(:glucose_level, member: member, value: 140, tested_at: 4.days.ago)

          # Previous week readings
          create(:glucose_level, member: member, value: 160, tested_at: 8.days.ago)
          create(:glucose_level, member: member, value: 190, tested_at: 9.days.ago) # above range
          create(:glucose_level, member: member, value: 65, tested_at: 10.days.ago) # below range
          create(:glucose_level, member: member, value: 145, tested_at: 11.days.ago)
        end

        it 'calculates metrics and changes correctly' do
          metrics = service.calculate_metrics

          # Current week metrics
          expect(metrics[:average_glucose]).to eq(137.5) # (150 + 200 + 60 + 140) / 4
          expect(metrics[:time_above_range]).to eq(25.0)  # 1 out of 4 readings
          expect(metrics[:time_below_range]).to eq(25.0)  # 1 out of 4 readings

          # Previous week metrics
          previous_avg = 140.0 # (160 + 190 + 65 + 145) / 4
          previous_above = 25.0 # 1 out of 4 readings
          previous_below = 25.0 # 1 out of 4 readings

          # Changes
          expect(metrics[:average_glucose_change]).to eq(-1.79) # ((137.5 - 140.0) / 140.0 * 100).round(2)
          expect(metrics[:time_above_range_change]).to eq(0.0)  # No change in percentage
          expect(metrics[:time_below_range_change]).to eq(0.0)  # No change in percentage
        end
      end
    end

    context 'with monthly time frame' do
      let(:time_frame) { :month }

      context 'when there are no readings' do
        it 'returns zero values for all metrics and changes' do
          metrics = service.calculate_metrics

          expect(metrics).to eq({
            average_glucose: 0,
            time_above_range: 0,
            time_below_range: 0,
            average_glucose_change: 0,
            time_above_range_change: 0,
            time_below_range_change: 0
          })
        end
      end

      context 'when there are readings' do
        before do
          # Current month readings
          create(:glucose_level, member: member, value: 150, tested_at: Time.current.beginning_of_month + 1.day)
          create(:glucose_level, member: member, value: 200, tested_at: Time.current.beginning_of_month + 2.days) # above range
          create(:glucose_level, member: member, value: 60, tested_at: Time.current.beginning_of_month + 3.days)  # below range
          create(:glucose_level, member: member, value: 140, tested_at: Time.current.beginning_of_month + 4.days)

          # Previous month readings
          create(:glucose_level, member: member, value: 160, tested_at: 1.month.ago.beginning_of_month + 1.day)
          create(:glucose_level, member: member, value: 190, tested_at: 1.month.ago.beginning_of_month + 2.days) # above range
          create(:glucose_level, member: member, value: 65, tested_at: 1.month.ago.beginning_of_month + 3.days) # below range
          create(:glucose_level, member: member, value: 145, tested_at: 1.month.ago.beginning_of_month + 4.days)
        end

        it 'calculates metrics and changes correctly' do
          metrics = service.calculate_metrics

          # Current month metrics
          expect(metrics[:average_glucose]).to eq(137.5) # (150 + 200 + 60 + 140) / 4
          expect(metrics[:time_above_range]).to eq(25.0)  # 1 out of 4 readings
          expect(metrics[:time_below_range]).to eq(25.0)  # 1 out of 4 readings

          # Previous month metrics
          previous_avg = 140.0 # (160 + 190 + 65 + 145) / 4
          previous_above = 25.0 # 1 out of 4 readings
          previous_below = 25.0 # 1 out of 4 readings

          # Changes
          expect(metrics[:average_glucose_change]).to eq(-1.79) # ((137.5 - 140.0) / 140.0 * 100).round(2)
          expect(metrics[:time_above_range_change]).to eq(0.0)  # No change in percentage
          expect(metrics[:time_below_range_change]).to eq(0.0)  # No change in percentage
        end
      end
    end

    context 'with invalid time frame' do
      let(:time_frame) { :invalid }

      it 'raises an ArgumentError' do
        expect { service.calculate_metrics }.to raise_error(ArgumentError, 'Invalid time frame: invalid')
      end
    end
  end
end
