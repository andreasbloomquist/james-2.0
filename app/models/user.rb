class User < ActiveRecord::Base
  has_many :leads
  has_many :appointments

  def update_to_inactive
    update_column(:is_inactive, true)
  end

  def update_to_active
    update_column(:is_inactive, false)
  end


  private
  @@client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']

  def create_sms_msg(to, body)
    @@client.messages.create({
        from: '+14158010226',
        to: to,
        body: body
      })
  end

end
