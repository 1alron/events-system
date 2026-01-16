module API
  module V1
    class Events < Grape::API
      resource :events do
        # GET /api/v1/events
        desc "Получить список всех мероприятий",
             is_array: true,
             success: API::Entities::Events::Base
        get do
          events = Event.all
          present events, with: API::Entities::Events::Base
        end

        # Общий блок для маршрутов с :id
        route_param :id, type: Integer do
          before do
            @event = Event.find(params[:id])
          end

          # GET /api/v1/events/:id
          desc "Получить информацию о мероприятии",
               success: API::Entities::Events::Base
          get do
            present @event, with: API::Entities::Events::Base
          end

          #   # Другие маршруты для конкретного мероприятия
          #   # GET /api/v1/events/:id/tickets
          #   desc 'Получить билеты мероприятия',
          #        is_array: true,
          #        success: API::Entities::Tickets::Base
          #   get :tickets do
          #     tickets = @event.tickets
          #     present tickets, with: API::Entities::Tickets::Base
          #   end
          #
          #   # GET /api/v1/events/:id/categories
          #   desc 'Получить категории мероприятия',
          #        is_array: true,
          #        success: API::Entities::EventCategories::Base
          #   get :categories do
          #     categories = @event.event_categories
          #     present categories, with: API::Entities::EventCategories::Base
          #   end
        end
      end
    end
  end
end
