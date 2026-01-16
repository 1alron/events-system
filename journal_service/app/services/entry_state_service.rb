class EntryStateService
  def self.inside?(ticket_id)
    last = EntryLog.where(ticket_id: ticket_id)
                   .order(occurred_at: desc)
                   .first
    
    last&.action == 'entry' && last&.successful?
  end
end