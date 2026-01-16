module API
  module V1
    class Reservations < Grape::API
      resource :reservations do
        desc "Получить список всех бронирований",
             is_array: true,
             success: { model: "API::Entities::Reservations::Base", is_array: true }
        params do
          optional :include_inactive,
                   type: Boolean,
                   default: false,
                   desc: "Включить неактивные бронирования"
        end
        get do
          reservations = Reservation.all
          reservations = reservations.where(active: true) unless params[:include_inactive]
          reservations = reservations.order(created_at: :desc)
          present reservations, with: API::Entities::Reservations::Base
        end

        desc "Получить список бронирований пользователя",
             is_array: true,
             success: { model: "API::Entities::Reservations::Base", is_array: true }
        params do
          requires :user_id,
                   type: Integer,
                   desc: "ID пользователя"
        end
        get "user/:user_id" do
          reservations = Reservation.where(user_id: params[:user_id])
                                    .order(created_at: :desc)
          present reservations, with: API::Entities::Reservations::Base
        end

        desc "Забронировать билет",
             success: { model: "API::Entities::Reservations::Base" }
        params do
          requires :event_id,
                   type: Integer,
                   desc: "ID мероприятия"
          requires :user_id,
                   type: Integer,
                   desc: "ID пользователя"
          requires :category_name,  # Изменено с :category на :category_name
                   type: String,
                   allow_blank: false,
                   desc: "Категория"
        end
        post do
          event_category = EventCategory.includes(:event)
                                        .for_category(params[:category_name])  # Исправлено
                                        .where(event_id: params[:event_id])
                                        .first

          error!("Категория не найдена для данного события", 404) unless event_category

          reservation = Reservation.create!(
            active: true,
            user_id: params[:user_id],
            valid_to: 5.minutes.from_now,
            event_category: event_category
          )

          CancelReservationJob.set(wait: 1.minutes).perform_later(reservation.id)

          present reservation, with: API::Entities::Reservations::Base
        end

        route_param :id, type: Integer do
          before do
            @reservation = Reservation.find(params[:id])
          end

          desc "Получить информацию о конкретном бронировании",
               success: { model: "API::Entities::Reservations::Base" }
          get do
            present @reservation, with: API::Entities::Reservations::Base
          end

          desc "Отменить бронь",
               success: { model: "API::Entities::Reservations::Base" }
          patch "cancel" do
            @reservation.update!(active: false)
            present @reservation, with: API::Entities::Reservations::Base
          end
        end
      end
    end
  end
end
