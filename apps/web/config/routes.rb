# frozen_string_literal: true

# Configure your routes here
# See: https://guides.hanamirb.org/routing/overview
#
# Example:
# get '/hello', to: ->(env) { [200, {}, ['Hello from Hanami!']] }

get '/users/new', to: 'users#new'
post '/users/signup', to: 'users#signup', as: 'signup'
get '/users/:id', to: 'users#show'
