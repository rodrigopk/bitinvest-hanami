# frozen_string_literal: true

require_relative '../interactor'

module Interactors
  module Users
    class Get
      include Bitinvest::Interactor

      expose :user

      def initialize(user_id, dependencies = {})
        @user_repository = dependencies.fetch(:user_repository) do
          UserRepository.new
        end

        @user_id = user_id
      end

      def call
        @user = @user_repository.find(@user_id)
        error!(InteractorErrors.user_not_found) if @user.nil?
      end
    end
  end
end
