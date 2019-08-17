# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Web::Controllers::Users::Show, type: :action do
  let(:action) { described_class.new(interactor: interactor) }
  let(:interactor) { class_double(Interactors::Users::Get) }

  let(:user) { instance_double(User) }
  let(:params) { { id: SecureRandom.uuid } }

  describe '#initialize' do
    it 'initializes without dependencies' do
      described_class.new
    end

    it 'initializes with dependencies' do
      described_class.new(interactor: interactor)
    end
  end

  describe '#call' do
    context 'without id parameter' do
      let(:params) { Hash[] }

      it 'halts with 404 status' do
        response = action.call(params)
        expect(response[0]).to eq(404)
      end
    end

    context 'id is present' do
      it 'fetchs the user with the provided id' do
        expect(interactor).to fetch_user_for_id

        action.call(params)
      end

      context 'user found' do
        it 'exposes the retrieved user' do
          allow(interactor).to fetch_user_for_id

          action.call(params)
          expect(action.exposures[:user]).to eq(user)
        end
      end

      context 'user not found' do
        it 'returns 404' do
          allow(interactor).to not_find_user_for_id

          response = action.call(params)
          expect(response[0]).to eq(404)
        end
      end
    end
  end

  private

  def fetch_user_for_id
    fetch_user_and_return(Hanami::Interactor::Result.new(user: user))
  end

  def not_find_user_for_id
    fetch_user_and_return(
      instance_double(
        Hanami::Interactor::Result,
        failure?: true,
        error: [:user_not_found],
      ),
    )
  end

  def fetch_user_and_return(result)
    receive(:call).with(params[:id]).and_return(result)
  end
end
