module SmsHelper
	
	def new_user?(number)
		return true if User.find_by_phone_number(number) == nil
	end

	def create_log(params)
		SmsLog.create({
			:from => params[:From],
			:to => params[:To],
			:body => params[:Body],
			:sms_id => params[:SmsSid]
			})
	end

	def check_question(number)
		@user = User.find_by_phone_number(number)
		@user_lead = @user.leads.last
		

	end

	def create_user(params)
		@client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']

		@question_one = "First, where are you looking- give me one or more neighborhoods: SOMA, FiDi, the Mission, Jackson Square"

		@user = User.create({
    		:phone_number => params[:From],
    		:name => params[:Body],
    		:city => params[:FromCity],
    		:state => params[:FromState]
    	})

		@user.leads.create({})

		 welcome_msg = {
    		:from => '+14158010226', 
        :to => @user.phone_number, 
        :body => "Hi #{@user.name}, I’m James I’m going to find you space. Just three or four simple questions to start off:"
      }

    @client.messages.create(welcome_msg)
	  
    message_one = {
    		:from => '+14158010226', 
        :to => @user.phone_number, 
        :body => @question_one
      }

    @client.messages.create(message_one)
    create_log(params)
	  render nothing: true
	end

end
