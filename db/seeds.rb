# Create a demo user
user = User.find_or_create_by!(email: "demo@flightschool.com") do |u|
  u.password = "password123"
  u.password_confirmation = "password123"
end

# Create a flight school
school = user.flight_schools.find_or_create_by!(name: "Skyline Aviation Academy") do |s|
  s.location = "Municipal Airport, Springfield"
end

# Create aircraft
aircraft_data = [
  { tail_number: "N172SP", model: "Cessna 172S Skyhawk SP" },
  { tail_number: "N152AB", model: "Cessna 152" },
  { tail_number: "N28HK", model: "Piper PA-28 Cherokee" },
  { tail_number: "N44CD", model: "Diamond DA40" }
]

aircraft_data.each do |data|
  school.aircrafts.find_or_create_by!(tail_number: data[:tail_number]) do |a|
    a.model = data[:model]
  end
end

# Add some downtime events
cessna172 = school.aircrafts.find_by(tail_number: "N172SP")
cessna152 = school.aircrafts.find_by(tail_number: "N152AB")

# Active downtime (currently down)
cessna152.downtime_events.find_or_create_by!(reason_type: "maintenance", started_at: 1.day.ago) do |e|
  e.ended_at = 2.days.from_now
  e.description = "100-hour inspection in progress"
  e.created_by = user
end

# Past downtime
cessna172.downtime_events.find_or_create_by!(reason_type: "breakdown", started_at: 2.weeks.ago) do |e|
  e.ended_at = 10.days.ago
  e.description = "Alternator replacement"
  e.created_by = user
end

puts "Seed data created!"
puts "Login with: demo@flightschool.com / password123"
