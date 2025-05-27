# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from ActionController::ParameterMissing do |e|
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
