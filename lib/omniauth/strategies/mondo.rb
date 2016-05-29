require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Mondo < OmniAuth::Strategies::OAuth2
      option :name, :mondo
      option :client_options, {
        :site => 'https://api.getmondo.co.uk',
        :authorize_url => 'https://auth.getmondo.co.uk',
        :token_url => 'https://api.getmondo.co.uk/oauth2/token',
      }

      uid { access_token.params['user_id'] }

      info do
        {
          :token => access_token.token,
          :expires_in => access_token.expires_in,
          :expires_at => Time.at(access_token.expires_at),
          :refresh_token => access_token.refresh_token,
          :name => accounts.first['description'],
        }
      end

      extra do
        {
          :accounts => accounts,
        }
      end

      def accounts
        @accounts ||= access_token.get('/accounts').parsed['accounts']
      end
    end
  end
end

OmniAuth.config.add_camelization 'mondo', 'Mondo'
