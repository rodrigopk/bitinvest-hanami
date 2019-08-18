# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Containers::Users, type: :container do
  it 'registers the user repository' do
    repository = described_class[:user_repository]
    expect(repository).to eq(UserRepository)
  end
end
