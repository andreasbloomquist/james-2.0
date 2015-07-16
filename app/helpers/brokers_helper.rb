module BrokersHelper
  @@client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']

  def send_lead(to, body)
    @@client.messages.create({
      :from => '+14158010226', 
      :to => to, 
      :body => body
      })
  end

  def trigger_lead(lead)
    @brokers = Broker.all
    bitly = Bitly.client.shorten("https://shrouded-ocean-9475.herokuapp.com/leads/#{lead.response_url}")
    message = "New lead - #{lead.q_one}, #{lead.q_two} ppl, #{lead.q_three}, #{lead.q_four}, Term length: #{lead.q_five}. Notes: #{lead.q_six}, Click here to respond #{bitly.short_url}"
    @brokers.each { |broker| send_lead(broker.phone_number, message) }
  end
end
