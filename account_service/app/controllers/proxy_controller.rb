class ProxyController < ApplicationController
  before_action :authorize!

  BOOKING_URL = ENV.fetch("BOOKING_URL")
  TICKETS_URL = ENV.fetch("TICKETS_URL")

  # Получение билетов пользователя
  def tickets_list
    response = HTTParty.get(
      "#{TICKETS_URL}/users/#{params[:user_id]}/tickets",
      headers: headers_json,
      query: { user_id: params[:id] }
    )
    render json: response
  end

  # Получение броней пользователей
  def reservations_list
    response = HTTParty.get(
      "#{BOOKING_URL}/users/#{params[:user_id]}/reservations",
      headers: headers_json,
      query: { user_id: params[:id] }
    )
    render json: response
  end

  # Получение цены
  def prices
    response = HTTParty.get(
      "#{BOOKING_URL}/prices",
      query: params.permit(:event_date, :category)
    )
    render json: response
  end

  # Создать бронь
  def create_reservation
    body = request.raw_post
    response = HTTParty.post(
      "#{BOOKING_URL}/reservations/create",
      headers: headers_json,
      body: body
    )
    render json: response
  end

  # Отменить бронь
  def cancel_reservation
    response = HTTParty.delete(
      "#{BOOKING_URL}/reservations/#{params[:reservation_id]}",
      headers: headers_json
    )
    render json: response
  end

  # Инфо о брони
  def reservation_info
    response = HTTParty.get(
      "#{BOOKING_URL}/reservations/#{params[:reservation_id]}",
      headers: headers_json
    )
    render json: response
  end

  # Купить билет
  def purchase_ticket
    body = request.raw_post
    response = HTTParty.post(
      "#{TICKETS_URL}/tickets/purchase",
      headers: headers_json,
      body: body
    )
    render json: response
  end

  # Получить билет
  def ticket_info
    response = HTTParty.get(
      "#{TICKETS_URL}/tickets/#{params[:ticket_id]}",
      headers: headers_json
    )
    render json: response
  end

  # Заблокировать билет
  def block_ticket
    body = request.raw_post
    response = HTTParty.post(
      "#{TICKETS_URL}/tickets/#{params[:ticket_id]}/block",
      headers: headers_json,
      body: body
    )
    render json: response
  end

  private

  def authorize!
    token = request.headers["Authorization"]
    decoded = JWT.decode(token, "secret") rescue nil
    render json: { error: "Unauthorized" }, status: :unauthorized unless decoded
  end

  def headers_json
    { "Content-Type" => "application/json" }
  end
end
