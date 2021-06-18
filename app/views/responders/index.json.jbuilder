json.responders do
  json.array! responders, partial: 'responder', as: :responder
end
