Rails.application.routes.draw do
  defaults format: :json do
    resources :emergencies, only: [:index, :create]
    resources :responders, only: [:index, :create]
    get 'emergencies/:code', to: 'emergencies#show', constraints: ->(req) { req.params[:code] != 'new' }
    match 'emergencies/:code', to: 'emergencies#update', via: [:patch, :put]
    get 'responders/:name', to: 'responders#show', constraints: ->(req) { req.params[:name] != 'new' }
    match 'responders/:name', to: 'responders#update', via: [:patch, :put]

    match '*any', to: 'errors#not_found', via: :all
  end
end
