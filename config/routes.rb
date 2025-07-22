Rails.application.routes.draw do
  root "weather#show"           # sets the main page to weather#show
  get "/weather" => "weather#show"

  get "up" => "rails/health#show", as: :rails_health_check
end
