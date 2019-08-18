# frozen_string_literal: true

module Containers
  class Services
    extend Dry::Container::Mixin

    register :password_encryption do
      BCrypt::Password
    end
  end
end
