json.emergency do
  json.partial! 'emergency', emergency: emergency
  json.responders dispatched_responders
  json.full_response full_response
end
