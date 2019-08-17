# frozen_string_literal: true

module Web
  module Controllers
    module Users
      class Show
        include Web::Action

        expose :user

        params do
          required(:id).filled(:str?)
        end

        def initialize(dependencies = {})
          @interactor_class = dependencies.fetch(:interactor) do
            Interactors::Users::Get
          end
        end

        def call(params)
          halt 404 unless params.valid?

          result = @interactor_class.call(params[:id])
          halt 404 if result.failure?

          @user = result.user
        end
      end
    end
  end
end
