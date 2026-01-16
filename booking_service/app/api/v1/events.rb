module API
  module V1
    class Events < Grape::API
      resource :events do
        desc "Получить список всех мероприятий",
             is_array: true,
             success: "API::Entities::Events::Base"
        get do
          events = Event.all
          present events, with: API::Entities::Events::Base
        end

        route_param :id, type: Integer do
          before do
            @event = Event.find(params[:id])
          end

          desc "Получить информацию о мероприятии",
               success: "API::Entities::Events::Base"
          get do
            present @event, with: API::Entities::Events::Base
          end

          resource "tickets" do
            desc "Получить список билетов по ID события",
                 success:  { model: "API::Entities::Tickets::Base", is_array: true }
            params do
              optional :category,
                       type: String,
                       desc: "Фильтр по категории"
            end
            get do
              tickets = @event.tickets
              tickets = tickets.where(event_category_id: params[:category_id]) if params[:category_id]
              tickets = tickets.order(created_at: :desc)

              present tickets, with: API::Entities::Tickets::Base
            end
          end

          resource "reservations" do
            desc "Получить список бронирований по ID события",
                 success: { model: "API::Entities::Reservations::Base", is_array: true }
            params do
              optional :category_id,
                       type: Integer,
                       desc: "Фильтр по ID категории"
            end
            get do
              reservations = @event.reservations
              reservations = reservations.where(event_category_id: params[:category_id]) if params[:category_id]
              reservations = reservations.order(created_at: :desc)

              present reservations, with: API::Entities::Reservations::Base
            end
          end
        end
      end
    end
  end
end
