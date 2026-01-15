
event1 = Event.create!(name: "Концерт 1", date: 2.weeks.from_now)
event2 = Event.create!(name: "Концерт 1", date: 3.weeks.from_now)



Reservation.create!(
  event: event1,
  user_id: 1,
  active: true,
  valid_to: 1.day.from_now,
  category: :vip
)

Reservation.create!(
  event: event1,
  user_id: 2,
  active: true,
  valid_to: 1.day.from_now,
  category: :fanzone
)


Ticket.create!(
  event: event1,
  user_id: 1,
  blocked: false,
  category: :vip
)

Ticket.create!(
  event: event1,
  user_id: 2,
  blocked: false,
  category: :vip
)

Ticket.create!(
  event: event1,
  user_id: 3,
  blocked: false,
  category: :fanzone
)

Ticket.create!(
  event: event1,
  user_id: 4,
  blocked: true,
  category: :fanzone
)