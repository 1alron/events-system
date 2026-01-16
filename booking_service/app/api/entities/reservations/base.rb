module API
  module Entities
    module Reservations
    class Base < Grape::Entity
      expose :id,
             documentation: {
               type: Integer,
               desc: "Идентификатор",
               example: 123
             }

      expose :active,
             documentation: {
               type: "Boolean",
               desc: "Признак активности брони",
               example: false
             }

      expose :event_id,
             documentation: {
               type: Integer,
               desc: "Идентификатор связанного события",
               example: 1
             }

      expose :user_id,
             documentation: {
               type: Integer,
               desc: "Идентификатор пользователя-владельца",
               example: 42
             }

      expose :event_category,
             documentation: {
               type: String,
               desc: "Категория",
               example: "VIP"
             } do |reservation|
        reservation.event_category.category.name
      end

      expose :event_name,
             documentation: {
               type: String,
               desc: "Название мероприяти",
               example: "Концерт"
             } do |reservation|
        reservation.event.name
      end

        expose :event_date,
               documentation: {
                 type: String,
                 desc: "Дата мероприятия",
                 example: "15.06.2027 10:30"
               } do |reservation|
          reservation.event.date.strftime("%d.%m.%Y %H:%M")
        end

      expose :valid_to,
             documentation: {
               type: String,
               desc: "Время, до которого валидна бронь",
               example: "15.06.2027 10:30"
             }


      private

      def formatted_date(date)
        date.strftime("%d.%m.%Y %H:%M") if date.present?
      end
    end
    end
  end
end
