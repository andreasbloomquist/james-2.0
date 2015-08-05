Broker.destroy_all

# Seeding brokers

Broker.create({
  first_name: "Alex",
  last_name: "Lassar",
  email: "alex.lassar@am.jll.com", 
  phone_number: "+13129275281", 
  company: "JLL"
  })
Broker.create({
  first_name: "Andreas",
  last_name: "Bloomquist",
  email: "andreasbloomquist.com", 
  phone_number: "+16178754788", 
  company: "GA"
  })
Broker.create({
  first_name: "Travis",
  last_name: "James",
  email: "travis.james@am.jll.com", 
  phone_number: "+16502480953", 
  company: "JLL"
  })
Broker.create({
  first_name: "Cody",
  last_name: "Bishop",
  email: "cody.bishop@am.jll.com", 
  phone_number: "+14158193717", 
  company: "JLL"
  })



# Admin.create({
#   email: "andreasbloomquist@gmail.com",
#   password: ENV['PASSWORD'],
#   broker_id: 2
#   }]
