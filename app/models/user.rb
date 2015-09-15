class User < ActiveRecord::Base
  has_many :leads
  has_many :appointments

  @@question_one = "First, where are you looking- give me one or more neighborhoods: SOMA, FiDi, the Mission, Jackson Square"

  def update_to_inactive
    update_column(:is_inactive, true)
  end

  def update_to_active
    update_column(:is_inactive, false)
  end

  def new_lead
    leads.create({})

    new_start_msg = 'Got it, you want to start over, not a problem!' 
    create_sms_msg(phone_number, new_start_msg)
    create_sms_msg(phone_number, @@question_one)
  end

  def self.create_user(params)
    @user = self.create({
        phone_number: params[:From],
        name: params[:Body],
        city: params[:FromCity],
        state: params[:FromState]
      })

     @user.leads.create({})

    welcome_msg = "Hi #{@user.name}, I’m James I’m going to find you space. Just three or four simple questions to start off:"

    # # send welcome message
    @user.create_sms_msg(@user.phone_number, welcome_msg)

    # # send first question
    @user.create_sms_msg(@user.phone_number, @@question_one)
  end

  @@client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']

  def create_sms_msg(to, body)
    @@client.messages.create({
        from: '+14158010226',
        to: to,
        body: body
      })
  end

end
