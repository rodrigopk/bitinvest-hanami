# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Containers::Services, type: :container do
  it 'registers the password encription service' do
    service = described_class[:password_encryption]
    expect(service).to eq(BCrypt::Password)
  end
end
