class TurnstileController < ApplicationController
  def entry
    process(:entry)
  end

  def exit
    process(:exit)
  end

  private

  def process(action)
    ticket_id = params[:ticket_id]
    turnstile_category = params[:turnstile_category]

    ticket = TicketServiceClient.get_ticket(ticket_id)

    unless ticket
      return render_fail(action, ticket_id, "Билет не найден")
    end

    if ticket['blocked']
      return render_fail(action, ticket_id, "Билет заблокирован", ticket)
    end

    if ticket['category'] != turnstile_category
      return render_fail(action, ticket_id, "Неверная категория турникета", ticket)
    end

    if Date.parse(ticket['event_date']) != Date.today
      return render_fail(action, ticket_id, "Неверная дата мероприятия", ticket)
    end

    if action == :entry && EntryStateService.inside?(ticket_id)
      return render_fail(action, ticket_id, "Повторный вход без выхода", ticket)
    end

    if action == :exit && !EntryStateService.inside?(ticket_id)
      return render_fail(action, ticket_id, "Нельзя выйти: посетитель не внутри", ticket)
    end

    log_success(action, ticket, turnstile_category)

    render json: { status: true }
  end

  def log_success(action, ticket, turnstile_category)
    EntryLog.create!(
      ticket_id: ticket['ticket_id'],
      full_name: fetch_user_name(ticket['user_id']),
      event_date: ticket['event_date'],
      ticket_category: ticket['category'],
      turnstile_category: turnstile_category,
      action: action,
      successful: true,
      occurred_at: Time.current
    )
  end

  def render_fail(action, ticket_id, message, ticket = nil)
    EntryLog.create!(
      ticket_id: ticket_id,
      full_name: nil,
      event_date: ticket&.dig('event_date'),
      ticket_category: ticket&.dig('category'),
      turnstile_category: params[:turnstile_category],
      action: action,
      successful: false,
      message: message,
      occurred_at: Time.current
    )

    render json: { status: false, message: message }
  end

  def fetch_user_name(user_id)
    #TODO получать имя либо по id, либо из билета
    "user service name"
  end
end