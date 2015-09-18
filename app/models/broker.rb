class Broker < ActiveRecord::Base
  has_many :properties
  validates :email, uniqueness: true
  validates :first_name, :last_name, :email, :phone_number, presence: true

  @@client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']

  def create_sms_msg(to, body)
    @@client.messages.create({
        from: '+14158010226',
        to: to,
        body: body
      })
  end

  def self.is_broker?(number)
    @broker = Broker.find_by_phone_number(number)
    return @broker unless @broker == nil
  end

  def set_auth_code
    auth_code = rand(10000)
    update_column(:auth_code, auth_code)
    auth_message = "Your authorization code is #{auth_code}"
    create_sms_msg(phone_number, auth_message)
  end

  def self.resubmit_lead(lead)
    bitly = Bitly.client.shorten("https://www.textjames.co/leads/#{lead.response_url}")
    lead_msg = "Response requested for a previously submitted lead. #{lead.q_one}, #{lead.q_two} people, Term length: #{lead.q_five}, Notes: #{lead.q_six}, Click here to respond #{bitly.short_url}"
    self.all.each { |broker| broker.create_sms_msg(broker.phone_number, lead_msg) }
  end

end
