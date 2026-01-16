module API
  module Entities
    module Events
      class Base < Grape::Entity
        expose :id,
               documentation: {
                 type: Integer,
                 desc: "Идентификатор мероприятия",
                 example: 123
               }

        expose :name,
               documentation: {
                 type: String,
                 desc: "Название мероприятия",
                 example: "Концерт какой-то группы"
               }

        expose :date,
               documentation: {
                 type: String,
                 desc: "Дата мероприятия",
                 example: "15.06.2027 10:30"
               } do |event|
          event.date.strftime("%d.%m.%Y %H:%M")
        end

        expose :event_categories,
               using: "API::Entities::EventCategories::Base",
               documentation: {
                 type: "API::Entities::EventCategories::Base",
                 desc: "Категории билетов",
                 is_array: true
               }

        private

        def formatted_date(date)
          date.strftime("%d.%m.%Y %H:%M") if date.present?
        end
      end
    end
  end
end
