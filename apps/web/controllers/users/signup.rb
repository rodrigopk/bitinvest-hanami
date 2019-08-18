# frozen_string_literal: true

module Web
  module Controllers
    module Users
      class Signup
        include Web::Action

        VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

        params do
          required(:user).schema do
            required(:email) { filled? & format?(VALID_EMAIL_REGEX) }
            required(:first_name).filled(:str?)
            optional(:last_name).filled(:str?)
            required(:password).filled(:str?)
          end
        end

        def initialize(dependences = {})
          @interactor = dependences.fetch(:interactor) do
            Interactors::Users::Signup
          end
        end

        def call(params)
          redirect_to_signup_form unless params.valid?

          result = @interactor.call(params[:user])

          redirect_to_signup_form if result.failure?
          redirect_to(routes.users_show_path(result.user.id))
        end

        private

        def redirect_to_signup_form
          redirect_to(routes.users_new_path)
        end
      end
    end
  end
end
