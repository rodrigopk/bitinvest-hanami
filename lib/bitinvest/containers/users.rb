# frozen_string_literal: true

module Containers
  class Users
    extend Dry::Container::Mixin

    register :user_repository do
      UserRepository
    end
  end
end
