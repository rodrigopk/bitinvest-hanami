# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Interactors::Users::Get, type: :interactor do
  let(:interactor) { described_class }
  let(:user_repository) { instance_double(UserRepository) }
  let(:user_id) { 'user_id' }
  let(:user) { instance_double(User) }

  describe 'initialize' do
    it 'initializes without dependencies' do
      described_class.new(user_id)
    end

    it 'initializes with dependencies' do
      described_class.new(
        user_id,
        user_repository: user_repository,
      )
    end
  end

  describe '#call' do
    it 'fetchs the user for the provided id' do
      expect(user_repository).to fetch_user_and_return(user)

      call_interactor_with_dependencies
    end

    context 'user does not exists' do
      it 'fails' do
        allow(user_repository).to fetch_user_and_return(nil)

        result = call_interactor_with_dependencies
        expect(result.failure?).to be_truthy
      end

      it 'returns an error message' do
        allow(user_repository).to fetch_user_and_return(nil)

        result = call_interactor_with_dependencies
        expect(result.errors).to match_array([:user_not_found])
      end
    end

    context 'user for id is present' do
      it 'is successful' do
        allow(user_repository).to fetch_user_and_return(user)

        result = call_interactor_with_dependencies
        expect(result.successful?).to be_truthy
      end

      it 'exposes the retrieved user' do
        allow(user_repository).to fetch_user_and_return(user)

        result = call_interactor_with_dependencies
        expect(result.user).to eq(user)
      end
    end
  end

  private

  def fetch_user_and_return(result)
    receive(:find).with(user_id).and_return(result)
  end

  def call_interactor_with_dependencies
    interactor.call(user_id, user_repository: user_repository)
  end
end
