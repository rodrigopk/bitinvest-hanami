# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Web::Controllers::Users::Signup, type: :action do
  let(:action) { described_class.new(interactor: interactor) }
  let(:interactor) { class_double(Interactors::Users::Signup) }
  let(:valid_params) do
    {
      user: {
        first_name: 'Penelope',
        last_name: 'Cruz',
        email: 'penelope@cruz.com',
        password: 'password',
      },
    }
  end
  let(:user) { User.new(id: SecureRandom.uuid) }

  describe '#initialize' do
    it 'initializes without dependencies' do
      described_class.new
    end
  end

  describe '#call' do
    context 'empty parameters' do
      let(:params) { Hash[] }

      it { redirects_to_signup_form }
    end

    context 'without email' do
      let(:params) { parameters_without(:email) }

      it { redirects_to_signup_form }
    end

    context 'invalid email' do
      let(:params) do
        {
          user: {
            first_name: 'Penelope',
            email: 'penelope!cruz.com',
            password: 'password',
          },
        }
      end

      it { redirects_to_signup_form }
    end

    context 'missing first name' do
      let(:params) { parameters_without(:first_name) }

      it { redirects_to_signup_form }
    end

    context 'missing password' do
      let(:params) { parameters_without(:password) }

      it { redirects_to_signup_form }
    end

    context 'missing last_name' do
      let(:params) { parameters_without(:last_name) }

      it { redirects_to_user_detail }
    end

    context 'invalid last_name' do
      let(:params) do
        {
          user: {
            first_name: 'Penelope',
            last_name: 1245,
            email: 'penelope@cruz.com',
            password: 'password',
          },
        }
      end

      it { redirects_to_signup_form }
    end

    context 'valid parameters' do
      let(:params) { valid_params }

      context 'failed to create a user' do
        it 'redirects to signup form' do
          allow(interactor).to fail_to_create_an_user

          response = action.call(params)
          expect(response).to redirect_to('/users/new')
        end
      end

      context 'successfully created new user' do
        it { redirects_to_user_detail }
      end
    end
  end

  private

  def redirects_to_signup_form
    response = action.call(params)

    expect(response).to redirect_to('/users/new')
  end

  def parameters_without(key)
    { user: valid_params[:user].reject { |k, _v| k == key } }
  end

  def redirects_to_user_detail
    allow(interactor).to create_new_user

    response = action.call(params)
    expect(response).to redirect_to("/users/#{user.id}")
  end

  def create_new_user
    call_interactor_and_return(
      Hanami::Interactor::Result.new(user: user),
    )  
  end

  def fail_to_create_an_user
    call_interactor_and_return(
      instance_double(
        Hanami::Interactor::Result,
        failure?: true,
        errors: InteractorErrors.email_already_taken,
      ),
    )
  end

  def call_interactor_and_return(result)
    receive(:call).with(params[:user]).and_return(result)
  end
end
