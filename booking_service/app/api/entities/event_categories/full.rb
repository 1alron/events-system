module API
  module Entities
    module EventCategories
      class Full < Base
        expose :event_id,
               documentation: {
                 type: Integer,
                 desc: "ID мероприятия",
                 example: 12
               }

        expose :event_name,
               documentation: {
                 type: String,
                 desc: "Название мероприятия",
                 example: "Event 2"
               } do |event_category|
          event_category.event.name
        end
      end
    end
  end
end
