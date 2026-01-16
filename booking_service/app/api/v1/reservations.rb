module API
  module V1
    class Reservations < Grape::API
      resource :reservations do
        desc "Получить список всех бронирований",
             is_array: true,
             success:  { model: "API::Entities::Reservations::Base", is_array: true }
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

        resource :user do
          params do
            requires :user_id,
                     type: Integer,
                     desc: "ID пользователя"
          end
          get ":user_id" do
            reservations = Reservation.where(user_id: params[:user_id])
            present reservations, with: API::Entities::Reservation::Base
          end
        end

        route_param :id do
          before { @reservation = Reservation.find(params[:id]) }
          desc "Получить информацию о конкретном бронировании",
               success:  { model: "API::Entities::Reservations::Base" }
          get do
            present @reservation, with: API::Entities::Reservations::Base
          end
        end

        desc "Отменить бронь",
             success:  { model: "API::Entities::Reservations::Base" }
          patch "/cancel" do
            @reservation.update(active: false)
            present @reservation, with: API::Entities::Reservations::Base
            end
      end
    end
  end
end
