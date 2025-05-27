# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from ActionController::ParameterMissing do |e|
    render json: { error: e.message }, status: :unprocessable_entity
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { error: "Resource not found" }, status: :not_found
  end

  rescue_from ActionController::RoutingError do |e|
    render json: { error: "Route not found" }, status: :not_found
  end
end
