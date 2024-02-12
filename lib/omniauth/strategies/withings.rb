require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Withings < OmniAuth::Strategies::OAuth2
      option :name, 'withings'

      option :client_options, {
        :site => 'https://account.withings.com',
        :authorize_url => 'https://account.withings.com/oauth2_user/authorize2',
        :token_url => 'https://wbsapi.withings.net/v2/oauth2',
        :auth_scheme => :request_body,
        :access_token_class => OmniAuth::WithingsOauth2::AccessToken
      }

      option :scope, 'user.info'

      uid do
        raw_info['userid']
      end

      info do
        {
          'auth' => raw_info
        }
      end

      def callback_url
        full_host + script_name + callback_path
      end

      def build_access_token
        verifier = request.params["code"]
        response = client.auth_code.get_token(
          verifier,
          {
            :redirect_uri => callback_url,
            action: 'requesttoken',
            client_id: options.client_id,
            client_secret: options.client_secret,
            code: verifier,
            grant_type: 'authorization_code'
          }.merge(token_params.to_hash(:symbolize_keys => true)),
          deep_symbolize(options.auth_token_params))
      end

      alias :oauth2_access_token :access_token

      def access_token
        ::OAuth2::AccessToken.new(client, oauth2_access_token.token, {
          :expires_in => oauth2_access_token.expires_in,
          :expires_at => oauth2_access_token.expires_at
        })
      end

      def raw_info
        oauth2_access_token
      end
    end
  end
end

OmniAuth.config.add_camelization 'withings', 'Withings'
