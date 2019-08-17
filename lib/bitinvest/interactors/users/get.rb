# frozen_string_literal: true

require_relative '../interactor'

module Interactors
  module Users
    class Get
      include Bitinvest::Interactor

      expose :user

      USER_NOT_FOUND_ERROR = :user_not_found

      def initialize(user_id, dependencies = {})
        @user_repository = dependencies.fetch(:user_repository) do
          UserRepository.new
        end

        @user_id = user_id
      end

      def call
        @user = @user_repository.find(@user_id)
        error!(USER_NOT_FOUND_ERROR) if @user.nil?
      end
    end
  end
end
