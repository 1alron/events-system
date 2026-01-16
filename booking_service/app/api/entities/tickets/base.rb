module API
  module Entities
    module Tickets
    class Base < Grape::Entity
      expose :id,
             documentation: {
               type: Integer,
               desc: "Идентификатор билета",
               example: 123
             }

      expose :user_name,
             as: :user_fio,
             documentation: {
               type: String,
               desc: "ФИО владельца билета",
               example: "Иван Иванович Иванов"
             }

      expose :blocked,
             documentation: {
               type: "Boolean",
               desc: "Статус блокировки билета",
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
               desc: "Категория билета",
               example: "VIP"
             } do |ticket|
        ticket.event_category.category.name
        end

        expose :event_date,
               documentation: {
                 type: String,
                 desc: "Дата мероприятия",
                 example: "15.06.2027 10:30"
               } do |ticket|
          ticket.event_category.event.date.strftime("%d.%m.%Y %H:%M")
          end

      private

      def formatted_date(date)
        date.strftime("%d.%m.%Y %H:%M") if date.present?
      end
    end
    end
  end
end
