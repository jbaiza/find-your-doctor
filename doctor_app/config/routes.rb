Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  match "map", to: "map#show", via: [:get]

  match "institutions/search", to: "institutions#search", via: [:get]

  match "specialist_assignments/partial_list", to: "specialist_assignments#partial_list", via: [:get]

  root to: 'map#show'
end
