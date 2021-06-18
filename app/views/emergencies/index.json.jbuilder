json.emergencies do
  json.array! emergencies, partial: 'emergency', as: :emergency
end
json.full_responses full_responses
