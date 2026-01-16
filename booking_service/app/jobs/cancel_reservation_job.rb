class CancelReservationJob < ApplicationJob
  queue_as :default

  def perform(reservation_id)
    reservation = Reservation.find_by(id: reservation_id)

    # Если бронь не найдена или уже не активна (например, выкуплена), ничего не делаем
    return unless reservation&.active?

    # Проверяем, действительно ли время вышло (защита от случайного запуска раньше времени)
    if Time.current > reservation.valid_to
      reservation.update!(active: false)
      Rails.logger.info "Reservation ##{reservation_id} was automatically cancelled."
    end
  end
end
