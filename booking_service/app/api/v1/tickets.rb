module API
  module V1
    class Tickets < Grape::API
      resource :tickets do
        # Маршрут для получения цены билета
        desc "Рассчитать стоимость билета"
        params do
          requires :event_id, type: Integer, desc: "ID мероприятия"
          requires :category_name, type: String, desc: "Название категории (vip, fanzone, standard, economy)"
        end
        get "price" do
          # Находим категорию по имени
          category = Category.find_by(name: params[:category_name])
          error!("Категория не найдена", 404) unless category

          # Находим связь мероприятия с категорией
          event_category = EventCategory.find_by(
            event_id: params[:event_id],
            category_id: category.id
          )
          error!("Мероприятие или связь с категорией не найдены", 404) unless event_category

          # Проверяем доступность билетов
          if event_category.sold_and_reserved >= event_category.available_tickets
            error!("Билеты данной категории распроданы", 400)
          end

          price = event_category.current_price

          {
            success: true,
            event_id: event_category.event_id,
            event_name: event_category.event.name,
            category_name: event_category.category.name,
            base_price: event_category.base_price,
            current_price: price,
            occupied_tickets: event_category.sold_and_reserved,
            available_tickets: event_category.available_tickets,
            tickets_available: event_category.available_tickets - event_category.sold_and_reserved
          }
        end

        # Маршрут для получения всех цен мероприятия
        desc "Получить все цены для мероприятия"
        params do
          requires :event_id, type: Integer, desc: "ID мероприятия"
        end
        get ":event_id/prices" do
          event = Event.find(params[:event_id])

          prices = event.event_categories.map do |ec|
            {
              category_id: ec.category_id,
              category_name: ec.category.name,
              base_price: ec.base_price,
              current_price: ec.current_price,
              occupied_tickets: ec.sold_and_reserved,
              available_tickets: ec.available_tickets,
              tickets_available: ec.available_tickets - ec.sold_and_reserved
            }
          end

          {
            success: true,
            event_id: event.id,
            event_name: event.name,
            event_date: event.date,
            categories_count: prices.count,
            categories: prices
          }
        end

        # Тестовый маршрут для проверки
        desc "Проверка работы API"
        get "status" do
          {
            status: "ok",
            service: "booking",
            timestamp: Time.current.iso8601,
            models: {
              events: Event.count,
              categories: Category.count,
              event_categories: EventCategory.count,
              tickets: Ticket.count,
              reservations: Reservation.count
            }
          }
        end
      end
    end
  end
end
