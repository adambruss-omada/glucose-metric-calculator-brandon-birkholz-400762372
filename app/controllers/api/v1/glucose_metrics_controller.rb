module Api
  module V1
    class GlucoseMetricsController < ApplicationController
      before_action :authenticate_member
      before_action :validate_time_frame

      def show
        metrics = GlucoseMetricsService.new(current_member, @time_frame).calculate_metrics
        render json: metrics
      end

      private

      def authenticate_member
        token = request.headers['Authorization']&.split(' ')&.last
        return render json: { error: 'Unauthorized' }, status: :unauthorized unless token

        @current_member = AuthService.decode_token(token)
        render json: { error: 'Invalid token' }, status: :unauthorized unless @current_member
      end

      def validate_time_frame
        @time_frame = params[:time_frame]&.to_sym
        unless [:week, :month].include?(@time_frame)
          render json: { error: 'Invalid time frame. Must be either "week" or "month"' }, status: :bad_request
        end
      end

      def current_member
        @current_member
      end
    end
  end
end
