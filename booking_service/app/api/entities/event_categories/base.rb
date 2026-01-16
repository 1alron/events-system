module API
  module Entities
    module EventCategories
      class Base < Grape::Entity
        expose :base_price,
               documentation: {
                 type: Integer,
                 desc: "Базовая цена билета",
                 example: 1230
               }

        expose :name,
               documentation: {
                 type: String,
                 desc: "Название категории",
                 example: "VIP"
               } do |event_category|
          event_category.category.name
        end

        expose :current_price,
               documentation: {
                 type: BigDecimal,
                 desc: "Текущая цена билета",
                 example: 1500.50
               } do |event_category|
          event_category.current_price
          end

        expose :available_tickets,
               documentation: {
                 type: Integer,
                 desc: "Количество свободных билетов для покупки",
                 example: 75
               } do |event_category|
          event_category.available_tickets
          end
      end
    end
  end
end
