class CapacityChecker
  attr_accessor :emergencies, :responders

  class << self
    def call(*args)
      new(*args).call
    end
  end

  def initialize(emergencies, responders)
    self.emergencies = emergencies
    self.responders = responders
  end

  def call
    availability.transform_values { |type| type.map { |e| e.is_a?(Integer) ? e : e.sum(:capacity) } }
  end

  private

  def availability
    %w(Fire Police Medical).map do |e|
      type_responders = responders.send(e)
      duty_responders = type_responders.where(on_duty: true)
      [e, [type_responders,
           unresolved_emergencies? ? type_responders : available_capacities(e, type_responders)[:available],
           duty_responders,
           unresolved_emergencies? ? duty_responders : available_capacities(e, type_responders)[:jump_available]]]
    end.to_h
  end

  def unresolved_emergencies?
    @unresolved_emergencies ||= emergencies.where(resolved_at: nil).empty?
  end

  def available_capacities(type, type_responders)
    duty_responders = type_responders.where(on_duty: true)
    if duty_responders.count == 1
      { available: type_responders.where(on_duty: false), jump_available: 0 }
    else
      assigned_ids = type_responders.where(capacity: emergencies.sum("#{type.capitalize}_severity")).ids
      available_capacity = type_responders.where.not(id: assigned_ids)
      jump_capacity = duty_responders.where.not(id: assigned_ids)
      { available: available_capacity, jump_available: jump_capacity }
    end
  end
end
