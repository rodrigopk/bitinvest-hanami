# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Interactors::Users::Signup, type: :interactor do
  let(:interactor) { described_class }

  let(:dependencies) do
    { user_repository: user_repository, encryption_service: encryption_service }
  end
  let(:user_repository) { instance_double(UserRepository) }
  let(:encryption_service) { class_double(BCrypt::Password) }

  let(:email) { 'penelope@cruz.com' }
  let(:password) { 'password' }
  let(:hashed_password) { 'hashed_password' }
  let(:first_name) { 'Penelope' }
  let(:last_name) { 'Cruz' }

  describe '#initialize' do
    it 'initializes without dependencies' do
      described_class.new(
        email: email,
        password: password,
        first_name: first_name,
        last_name: last_name,
      )
    end
  end

  describe '#call' do
    it 'calls' do
      allow(encryption_service).to hash_password
      allow(user_repository).to create_new_user

      call_interactor_with_dependencies
    end

    it 'encrypts the user password' do
      expect(encryption_service).to hash_password
      allow(user_repository).to create_new_user

      call_interactor_with_dependencies
    end

    context 'user for email already exists' do
      it 'fails' do
        allow(encryption_service).to hash_password
        allow(user_repository)
          .to create_new_user
          .and_raise(Hanami::Model::UniqueConstraintViolationError)

        result = call_interactor_with_dependencies
        expect(result.failure?).to be_truthy
      end

      it 'fails with correct error' do
        allow(encryption_service).to hash_password
        allow(user_repository)
          .to create_new_user
          .and_raise(Hanami::Model::UniqueConstraintViolationError)

        result = call_interactor_with_dependencies
        expect(result.errors).to eq([InteractorErrors.email_already_taken])
      end
    end

    context 'user created successfuly' do
      it 'exposes the created account' do
        user = instance_double(User)

        allow(encryption_service).to hash_password
        allow(user_repository).to create_new_user.and_return(user)

        result = call_interactor_with_dependencies
        expect(result.user).to eq(user)
      end
    end
  end

  private

  def hash_password
    receive(:create).with(password).and_return(hashed_password)
  end

  def create_new_user
    receive(:create)
      .with(
        email: email,
        password: hashed_password,
        first_name: first_name,
        last_name: last_name,
      )
  end

  def call_interactor_with_dependencies
    interactor.call(
      email: email,
      password: password,
      first_name: first_name,
      last_name: last_name,
      dependencies: dependencies,
    )
  end
end
