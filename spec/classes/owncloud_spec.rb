require 'spec_helper'

describe 'owncloud' do
  let(:node) { 'testhost.example.org' }
  let(:hiera_config) { 'spec/fixtures/hiera/hiera.yaml' }

  context 'with default settngs' do
    it do
      should compile
     end
  end
end
