module API
  module Concerns
    module HttpClient
      extend ActiveSupport::Concern

      included do
        helpers do
          def http_client
            @http_client ||= HttpClient.new
          end
        end
      end

      class HttpClient
        def get(url, params = {})
          HTTParty.get(
            url,
            headers: default_headers,
            query: params,
            timeout: 5
          )
        end

        def default_headers
          {
            'Content-Type' => 'application/json',
            'Accept' => 'application/json'
          }
        end

        def account_service
          @account_service ||= AccountServiceClient.new
        end
      end

      class AccountServiceClient < HttpClient
        BASE_URL = ENV.fetch('ACCOUNT_SERVICE_URL', 'http://account:3000')

        def user_info(user_id)
          get("#{BASE_URL}/users/#{user_id}/info")
        end
      end
    end
  end
end