module Api
  module V1
    class LocationsController < ApplicationController
      before_action :measure_execution_time

      def create
        location = Location.new(location_params)
        if location.save
          render json: { id: location.id, time_ns: @execution_time }, status: :created
        else
          render json: { errors: location.errors.full_messages, time_ns: @execution_time }, status: :unprocessable_entity
        end
      end

      def by_category
        locations = Location.where(category: params[:category])
        render json: { locations: locations, time_ns: @execution_time }
      end

      def search
        begin
          locations = Location.nearby(
            params[:latitude].to_f,
            params[:longitude].to_f,
            params[:category],
            params[:radius_km].to_f
          )
          render json: { locations: locations, time_ns: @execution_time }
        rescue => e
          render json: { 
            error: "Error searching nearby locations: #{e.message}",
            time_ns: @execution_time 
          }, status: :ok
        end
      end

      def trip_cost
        begin
          destination = Location.find(params[:id])
          # Note: In a real application, you would integrate with the TollGuru API here
          # For demonstration purposes, we'll return mock data
          total_cost = rand(20.0..50.0).round(2)
          fuel_cost = (total_cost * 0.7).round(2)
          toll_cost = (total_cost * 0.3).round(2)

          render json: {
            total_cost: total_cost,
            fuel_cost: fuel_cost,
            toll_cost: toll_cost,
            time_ns: @execution_time
          }
        rescue ActiveRecord::RecordNotFound
          render json: { 
            error: "Location not found",
            time_ns: @execution_time 
          }, status: :ok
        rescue => e
          render json: { 
            error: "Error calculating trip cost: #{e.message}",
            time_ns: @execution_time 
          }, status: :ok
        end
      end

      private

      def location_params
        params.require(:location).permit(:name, :address, :latitude, :longitude, :category)
      end

      def measure_execution_time
        start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC, :nanosecond)
        yield if block_given?
        @execution_time = Process.clock_gettime(Process::CLOCK_MONOTONIC, :nanosecond) - start_time
      end
    end
  end
end
