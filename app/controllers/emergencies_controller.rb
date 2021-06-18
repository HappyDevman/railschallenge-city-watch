class EmergenciesController < ApplicationController
  def index
    emergencies = Emergency.all
    full_responses = EmergencyResponseChecker.call(emergencies, responders)
    render :index, locals: { emergencies: emergencies, full_responses: full_responses }
  end

  def create
    emergency = Emergency.new(emergency_create_params)
    if emergency.save
      dispatched_responders = EmergencyDispatcher.call(emergency, responders)
      full_response = EmergencyResponseChecker.call([emergency], responders)
      render :create, status: :created, locals: { emergency: emergency, dispatched_responders: dispatched_responders,
                                                  full_response: full_response }
    else
      render json: { message: emergency.errors }, status: :unprocessable_entity
    end
  end

  def show
    if emergency
      render :show, locals: { emergency: emergency }
    else
      render json: { message: 'emergency not found' }, status: :not_found
    end
  end

  def update
    if emergency.update(emergency_update_params)
      render :show, locals: { emergency: emergency }
    else
      render json: { message: emergency.errors }, status: :unprocessable_entity
    end
  end

  private

  def emergency
    @emergency ||= Emergency.find_by(code: params[:code])
  end

  def responders
    Responder.all
  end

  def emergency_create_params
    params.require(:emergency).permit(:code, :fire_severity, :police_severity, :medical_severity)
  end

  def emergency_update_params
    params.require(:emergency).permit(:fire_severity, :police_severity, :medical_severity, :resolved_at)
  end
end
