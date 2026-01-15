Rails.application.routes.draw do
  # Сервис личного кабинета
  post "/users/register", to: "users#register"
  post "/users/login", to: "users#login"
  post "/users/logout", to: "users#logout"

  # Сервис бронирования
  get    "/users/:id/prices",                        to: "proxy#prices"
  get    "/users/:id/reservations",                  to: "proxy#reservations_list"
  post   "/users/:id/reservations/create",           to: "proxy#create_reservation"
  delete "/users/:id/reservations/:reservation_id",  to: "proxy#cancel_reservation"
  get    "/users/:id/reservations/:reservation_id",  to: "proxy#reservation_info"

  # Сервис билетов
  get    "/users/:id/tickets",                       to: "proxy#tickets_list"
  post   "/users/:id/tickets/purchase",              to: "proxy#purchase_ticket"
  get    "/users/:id/tickets/:ticket_id",            to: "proxy#ticket_info"
  post   "/users/:id/tickets/:ticket_id/block",      to: "proxy#block_ticket"
end
