class UserServiceClient
  include HTTParty
  base_uri ENV.fetch('USER_SERVICE_URL')
  
  def self.get_user(user_id)
    response = get("/users/#{user_id}")
    return nil unless response.success?
    response.parsed_response
  end
end