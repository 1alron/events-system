module API
  module V1
    class Tickets < Grape::API
      resource :tickets do
        desc "Получить список всех билетов",
             is_array: true,
             success:  { model: "API::Entities::Tickets::Base", is_array: true }

        params do
          optional :include_blocked,
                   type: Boolean,
                   default: false,
                   desc: "Включить заблокированные билеты"
        end
        get do
          tickets = Ticket.all
          tickets = tickets.where(blocked: false) unless params[:include_blocked]
          tickets = tickets.order(created_at: :desc)
          present tickets, with: API::Entities::Tickets::Base
        end

        desc "Получить список билетов пользователя по его ID",
             is_array: true,
             success: { model: "API::Entities::Tickets::Base", is_array: true }
        resource :user do
          params do
            requires :user_id,
                     type: Integer,
                     desc: "ID пользователя"
          end

          get ":user_id" do
            tickets = Ticket.where(user_id: params[:user_id])
            present tickets, with: API::Entities::Tickets::Base
          end
        end

        route_param :id do
          before { @ticket = Ticket.find(params[:id]) }
          desc "Получить информацию о конкретном билете",
               success:  { model: "API::Entities::Tickets::Base" }
          get do
            present @ticket, with: API::Entities::Tickets::Base
          end
        end

        desc "Заблокировать билет",
             success:  { model: "API::Entities::Tickets::Base" }

        params do
          requires :id,
                   type: Integer,
                   desc: "ID билета"
          requires :document_type,
                   type: String,
                   allow_blank: false,
                   desc: "Тип документа"
          requires :document_number,
                   type: Integer,
                   desc: "номер документа"
        end
          patch "/block" do
            if @ticket.blocked?
              error!("Билет уже заблокирован", 422)
            end
            # todo user_info
            @ticket.update(blocked: true)
            present @ticket, with: API::Entities::Tickets::Base


      resource :price do
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

    event_category = EventCategory.find_by(
      event_id: params[:event_id],
      category_id: category.id
    )
    error!("Мероприятие или связь с категорией не найдены", 404) unless event_category

    if event_category.sold_and_reserved >= event_category.available_tickets
      error!("Билеты данной категории распроданы", 400)
    end

    present event_category, with: API::Entities::EventsCategories::Full
  end
      end
            end
      end
    end
  end
end
