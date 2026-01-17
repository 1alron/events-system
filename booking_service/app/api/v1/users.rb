module API
  module V1
    class Users < Grape::API
      resource :users do
        route_param :id do
          desc "Получить список бронирований пользователя",
               is_array: true,
               success: { model: "API::Entities::Reservations::Base", is_array: true }
          get "resrvations" do
            reservations = Reservation.where(user_id: params[:id])
                                      .order(created_at: :desc)
            present reservations, with: API::Entities::Reservations::Base
          end

          desc "Получить список билетов пользователя",
               is_array: true,
               success: { model: "API::Entities::Tikckets::Base", is_array: true }
          get "tickets" do
            tickets = Ticket.where(user_id: params[:id])
                                      .order(created_at: :desc)
            present tickets, with: API::Entities::Tickets::Base
          end
        end
      end
    end
  end
end
