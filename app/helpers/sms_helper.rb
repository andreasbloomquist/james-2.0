module SmsHelper
	
	@question_one = "First, where are you looking- give me one or more neighborhoods: SOMA, FiDi, the Mission, Jackson Square"
	@question_two = "Ok, and how many people do you need space for?"
	@question_three = "Do you want a creative/tech or more traditional feel?"
	@question_four = "And when do you need it by? Plz give me a date ex: '9/1/15'"
	@question_five = "Great! Finally, respond with any notes or special requests and my brokers will get right on this!"

	def new_user?(number)
		return true if User.find_by_phone_number(number) == nil
	end

	def create_user(params)
		@user = User.create({
    		:phone_number => params[:From],
    		:name => params[:Body],
    		:city => params[:FromCity],
    		:state => params[:FromState]
    	})
		@user.leads.create({})

		@twiml = Twilio::TwiML::Response.new do |r|
	    r.Message "Hi #{@user.name}, I’m James I’m going to find you space. Just three or four simple questions to start off:"
	  end
	  render_twiml @twiml
	  send_message(@user.phone_number,@question_one)
	end

	# TODO
	# Figure out why body variable isn't being passed to Twilio
	def send_message(to,test)
    @client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
    message = @client.messages.create(
    		:from => '+14158010226', 
        :to => to, 
        :body => "")
  end

end
