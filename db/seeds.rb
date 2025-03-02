# db/seeds.rb

require 'faker'

# Hapus data customer yang sudah ada
Customer.delete_all

# Generate beberapa data dummy untuk Customer
10.times do |i|
  Customer.create!(
    customer_id: (Time.now.to_i + i).to_s,  # Menambahkan i untuk membuat setiap customer_id unik
    customer_name: Faker::Company.name,
    email: Faker::Internet.email
  )
end

puts "Created 10 dummy customers with emails"
