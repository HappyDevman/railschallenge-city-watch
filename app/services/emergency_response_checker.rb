class EmergencyResponseChecker
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
    full_responsible_emergencies = emergencies.select do |emergency|
      availability = true
      [:fire_severity, :police_severity, :medical_severity].each_with_index do |type, index|
        availability &&= emergency.send(type) <= responders.where(type: index).pluck(:capacity).sum
      end
      availability
    end
    return if full_responsible_emergencies.count.zero?

    [full_responsible_emergencies.count, emergencies.count]
  end
end
