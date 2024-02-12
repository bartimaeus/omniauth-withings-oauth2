require 'spec_helper'
require 'omniauth-withings-oauth2'

describe OmniAuth::Strategies::Withings do
  subject { OmniAuth::Strategies::Withings.new(nil) }

  it 'adds camelization for itself' do
    expect(OmniAuth::Utils.camelize('withings')).to eq('Withings')
  end

  describe '#client' do
    it 'has correct Withings site' do
      expect(subject.client.site).to eq('https://account.withings.com')
    end

    it 'has correct `authorize_url`' do
      expect(subject.client.options[:authorize_url]).to eq('https://account.withings.com/oauth2_user/authorize2')
    end

    it 'has correct `token_url`' do
      expect(subject.client.options[:token_url]).to eq('https://wbsapi.withings.net/v2/oauth2')
    end
  end

  describe '#callback_path' do
    it 'has the correct callback path' do
      expect(subject.callback_path).to eq('/auth/withings/callback')
    end
  end

  describe '#uid' do
    before :each do
      allow(subject).to receive(:raw_info) { Hash['userid' => 'uid'] }
    end

    it 'returns the id from raw_info' do
      expect(subject.uid).to eq('uid')
    end
  end

  describe '#info / #raw_info' do
    let(:access_token) { instance_double OAuth2::AccessToken }

    before :each do
      allow(subject).to receive(:raw_info) { Hash['something' => 'new'] }
      allow(subject).to receive(:access_token).and_return access_token
    end

    it 'returns auth key containing raw_info' do
      expect(subject.info).to have_key('auth')
    end
  end

  describe '#access_token' do
    let(:expires_in) { 3600 }
    let(:expires_at) { 946688400 }
    let(:token) { 'token' }
    let(:access_token) do
      instance_double OAuth2::AccessToken, :expires_in => expires_in,
        :expires_at => expires_at, :token => token
    end

    before :each do
      # allow(subject).to receive(:raw_info) { Hash['scope' => 'user.info', 'refresh_token' => token, 'access_token' => token, 'expires_at' => expires_at] }
      allow(subject).to receive(:oauth2_access_token).and_return access_token
    end

    specify { expect(subject.access_token.expires_in).to eq expires_in }
    specify { expect(subject.access_token.expires_at).to eq expires_at }
  end

  describe '#authorize_params' do
    describe 'scope' do
      before :each do
        allow(subject).to receive(:session).and_return({})
      end

      it 'sets default scope' do
        expect(subject.authorize_params['scope']).to eq('user.info')
      end
    end
  end
end
