class EmergencyDispatcher
  attr_accessor :emergency, :responders

  class << self
    def call(*args)
      new(*args).call
    end
  end

  def initialize(emergency, responders)
    self.emergency = emergency
    self.responders = responders
  end

  def call
    return unless duty_responders

    [:fire_severity, :police_severity, :medical_severity].each_with_object([]).with_index do |(e, result), index|
      type_responders = duty_responders.where(type: index)
      result << get_dispatched_responder(emergency.send(e), type_responders) if type_responders.present?
    end.flatten.compact
  end

  private

  def get_dispatched_responder(severity, responders)
    if severity >= responders.pluck(:capacity).max
      if severity >= responders.sum(:capacity)
        responders.pluck(:name)
      else
        get_possible_responders(severity, responders.pluck(:name, :capacity))
      end
    else
      responders.where(capacity: severity).pluck(:name)
    end
  end

  def get_possible_responders(severity, responders, result = [])
    sum = result.map(&:last).sum
    if sum == severity
      return result.map(&:first)
    elsif sum > severity
      return
    end
    responders.each_with_index do |responder, index|
      remaining = responders[(index + 1)..-1]
      iteration_result = get_possible_responders(severity, remaining, result + [responder])
      return iteration_result if iteration_result.present? && iteration_result.all? { |e| e.is_a?(String) }
    end
  end

  def duty_responders
    responders.where(on_duty: true)
  end
end
