class TicketServiceClient
  include HTTParty
  base_uri ENV.fetch('TICKET_SERVICE_URL')

  def self.get_ticket(ticket_id)
    response = get("/tickets/#{ticket_id}")

    return nil unless response.success?
    response.parsed_response
  end
end