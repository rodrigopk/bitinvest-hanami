# frozen_string_literal: true

# Configure your routes here
# See: https://guides.hanamirb.org/routing/overview
#
# Example:
# get '/hello', to: ->(env) { [200, {}, ['Hello from Hanami!']] }

get '/users/new', to: 'users#new', as: 'users_new'
post '/users/signup', to: 'users#signup', as: 'users_signup'
get '/users/:id', to: 'users#show', as: 'users_show'
