vip_category = Category.find_or_create_by!(name: 'vip') do |cat|
end

fanzone_category = Category.find_or_create_by!(name: 'fanzone') do |cat|
end

event1 = Event.create!(
  name: "Концерт 1",
  date: 2.weeks.from_now
)

event2 = Event.create!(
  name: "Концерт 2",
  date: 3.weeks.from_now
)

event1_vip = event1.add_category(vip_category, 5000)
event1_fanzone = event1.add_category(fanzone_category, 3000)


event2_vip = event2.add_category(vip_category, 4500)
event2_fanzone = event2.add_category(fanzone_category, 2500)

Reservation.create!(
  event: event1,
  event_category: event1_vip,
  user_id: 1,
  active: true,
  valid_to: 1.day.from_now
)

Reservation.create!(
  event: event1,
  event_category: event1_fanzone,
  user_id: 2,
  active: true,
  valid_to: 2.days.from_now
)

ticket1 = Ticket.create!(
  event: event1,
  event_category: event1_vip,
  user_id: 1,
  blocked: false
)

ticket2 = Ticket.create!(
  event: event1,
  event_category: event1_vip,
  user_id: 2,
  blocked: false
)

ticket3 = Ticket.create!(
  event: event1,
  event_category: event1_fanzone,
  user_id: 3,
  blocked: false
)

ticket4 = Ticket.create!(
  event: event1,
  event_category: event1_fanzone,
  user_id: 4,
  blocked: true
)
