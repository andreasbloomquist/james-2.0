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

  def send_help_sms
    help_msg = "So you need some help? That's what I'm here for! To enter a new search simply text 'start over'. If you want to ping our brokers about the last search you performed, text 'resubmit'. To stop receiving all messages, just text 'stop' :'( "
    create_sms_msg(phone_number, help_msg)
  end

  def resubmit_last_lead
    last_complete = leads.where(complete: true).last
    if last_complete
      user_msg = "James here to help! I'll ping my brokers to ensure you find the perfect space for you most recent request. As a reminder your last request was for a space in #{last_complete.q_one} for #{last_complete.q_two} people"
      create_sms_msg(phone_number, user_msg)
      Broker.resubmit_lead(last_complete)
    else 
      user_msg = "Hmm it doesn't look like you have any completed requests. You may either respond directly to the last question I sent, or reply 'start over' to start fresh"
      create_sms_msg(phone_number, user_msg)
    end
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
