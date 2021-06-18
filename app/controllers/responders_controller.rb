class RespondersController < ApplicationController
  def index
    responders = Responder.all
    if params[:show] == 'capacity'
      result = CapacityChecker.call(emergencies, responders)
      render :capacity, locals: { capacities: result }
    else
      render :index, locals: { responders: responders }
    end
  end

  def create
    responder = Responder.new(responder_create_params)
    if responder.save
      render :show, locals: { responder: responder }, status: :created
    else
      render json: { message: responder.errors }, status: :unprocessable_entity
    end
  end

  def show
    if responder
      render :show, locals: { responder: responder }
    else
      render json: { message: 'responder not found' }, status: :not_found
    end
  end

  def update
    if responder.update(responder_update_params)
      render :show, locals: { responder: responder }
    else
      render json: { message: responder.errors }, status: :unprocessable_entity
    end
  end

  private

  def responder
    @responder ||= Responder.find_by(name: params[:name])
  end

  def emergencies
    @emergencies ||= Emergency.all
  end

  def responder_create_params
    params.require(:responder).permit(:type, :name, :capacity)
  end

  def responder_update_params
    params.require(:responder).permit(:on_duty)
  end
end
