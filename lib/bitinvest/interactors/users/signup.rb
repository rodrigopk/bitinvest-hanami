# frozen_string_literal: true

require_relative '../interactor'

module Interactors
  module Users
    class Signup
      include Bitinvest::Interactor

      expose :user

      def initialize(
        email:, password:, first_name:, last_name:, dependencies: {}
      )
        inject_dependencies(dependencies)

        @user_attributes = user_attributes_from_parameters(
          email: email,
          password: password,
          first_name: first_name,
          last_name: last_name,
        )
      end

      def call
        @user = @user_repository.create(@user_attributes)
      rescue Hanami::Model::UniqueConstraintViolationError
        error!(InteractorErrors.email_already_taken)
      end

      private

      def inject_dependencies(dependencies)
        @user_repository = dependencies.fetch(:user_repository) do
          UserRepository.new
        end

        @encryption_service = dependencies.fetch(:encryption_service) do
          BCrypt::Password
        end
      end

      def user_attributes_from_parameters(params)
        {
          email: params[:email],
          password: @encryption_service.create(params[:password]),
          first_name: params[:first_name],
          last_name: params[:last_name],
        }
      end
    end
  end
end
