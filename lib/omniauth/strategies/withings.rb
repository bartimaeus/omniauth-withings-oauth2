require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Withings < OmniAuth::Strategies::OAuth2
      option :name, 'withings'

      option :client_options, {
        :site => 'https://account.withings.com',
        :authorize_url => 'https://account.withings.com/oauth2_user/authorize2',
        :token_url => 'https://account.withings.com/oauth2/token'
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
