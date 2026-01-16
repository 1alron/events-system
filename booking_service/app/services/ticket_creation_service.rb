class TicketCreationService
  attr_reader :reservation, :ticket, :error_message, :error_code

  def initialize(params)
    @reservation_id = params[:reservation_id]
    @user_id = params[:user_id]
    @first_name = params[:first_name]
    @second_name = params[:second_name]
    @family_name = params[:family_name]
    @birth_date = params[:birth_date]
  end

  def call
    find_reservation
    validate_reservation_ownership
    validate_reservation_active
    validate_user_age
    ActiveRecord::Base.transaction do
      create_ticket
      deactivate_reservation
    end

    self
  rescue => e
    @error_message = e.message
    @error_code = e.respond_to?(:status) ? e.status : 500
    self
  end

  def success?
    @ticket.present? && @error_message.blank?
  end

  private

  def find_reservation
    @reservation = Reservation.find_by(id: @reservation_id)
    raise ApiError.new('Бронирование не найдено', 404) unless @reservation
  end

  def validate_reservation_ownership
    if @reservation.user_id.present? && @reservation.user_id != @user_id
      raise ApiError.new('Бронирование оформлено на другого пользователя', 403)
    end
  end

  def validate_reservation_active
    unless @reservation.active
      raise ApiError.new('Срок бронирования истек или оно было отменено', 410)
    end
  end

  def validate_user_age
    event_date = @reservation.event.date
    age_at_event = event_date.year - @birth_date.year - (event_date.yday < @birth_date.yday).to_i

    if age_at_event < 13
      raise ApiError.new('На дату мероприятия пользователю должно быть не менее 13 лет', 422)
    end
  end

  def create_ticket
    user_full_name = [@family_name, @first_name, @second_name].join(' ')

    @ticket = Ticket.create!(
      user_id: @user_id,
      user_name: user_full_name,
      event_category_id: @reservation.event_category_id,
      event_id: @reservation.event.id,
      blocked: false
    )
  end

  def deactivate_reservation
    @reservation.update!(active: false)
  end
end

# Класс для ошибок API
class ApiError < StandardError
  attr_reader :status

  def initialize(message, status = 500)
    super(message)
    @status = status
  end
end