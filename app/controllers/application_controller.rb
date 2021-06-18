class ApplicationController < ActionController::Base
  rescue_from ActionController::UnpermittedParameters do |e|
    render json: { message: e.message }, status: :unprocessable_entity
  end
end
