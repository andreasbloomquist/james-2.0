module SmsHelper
  include BrokersHelper
  require 'securerandom'

  @@client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
	
  ###########
  # Helper method to check if the number texting Twilio is a new number to the system
  ###########

  def new_user?(number)
    return true if User.find_by_phone_number(number) == nil
  end
  
  ###########
  # Helper method to check if the users text is in response to a property
  ###########

  def property_respose?(body)
    return true unless Property.find_by_response_code(body) == nil
  end

  ###########
  # Helper method to send response to user after responding to property
  # and trigger sms to broker
  ###########

  def send_property_response(body)
    property = Property.find_by_response_code(body)
    broker_fn = property.broker.first_name
    lead = property.lead
    user = lead.user

    user_response = "Great! I’ll let #{broker_fn}, the broker, know you’re interested. You should head back very shortly, stay tuned!"

    broker_response = "Hey #{broker_fn}, you've got a new lead for the #{property.address} space! You can contact #{user.name} by calling or texting #{user.phone_number}"

    # Respond to user
    @@client.messages.create({
        :from => '+14158010226', 
        :to => user.phone_number, 
        :body => user_response
        })

    # Respond to broker
    @@client.messages.create({
        :from => '+14158010226', 
        :to => property.broker.phone_number, 
        :body => broker_response
        })
    return render nothing: true
  end

  #################
  # Helper method to add sms to log tabl
  #################

  def create_log(params)
    SmsLog.create({
      :from => params[:From],
      :to => params[:To],
      :body => params[:Body],
      :sms_id => params[:SmsSid]
      })
  end

  #############################################################################
  # Method to check the last question the user answered,
  # and respond with a follow question until all questions have been answered.
  #############################################################################

  def send_message(number, response)
    #Find user and last open lead by that user
    @user = User.find_by_phone_number(number)
    @user_lead = @user.leads.last

    ############
    # QUESTIONS
    ############
    # Hard coding questions that Twilio will send depending on the last question answered
    ######################################################################################

    @question_two = "Ok, and how many people do you need space for?"
    @question_three = "Do you want a creative/tech or more traditional feel?"
    @question_four = "And when do you need it by? Plz give me a date ex: '9/1/15'"
    @question_five = "Great! Finally, respond with any notes or special requests and my brokers will get right on this!"
    @sending_to_broker = "I have a team of brokers on this right now, so hang tight! I’ll reach out very soon with more info, no need to reply to this text"

    #################
    # QUESTIONS HASH
    #################
    # Questions hash has the truthy falsy values for each question.
    # This is used to quickly check if a question is answered
    ################################################################

    questions = {}
    questions[:case_one] = @user_lead.q_one === nil
    questions[:case_two] = @user_lead.q_two === nil
    questions[:case_three] = @user_lead.q_three === nil
    questions[:case_four] = @user_lead.q_four === nil

    ###########################
    # SELECT A MESSAGE TO SEND
    ###########################
    # The below checks if each question has been answered
    # If the question hasn't been answered then it records the response and sends a new message

    # Checks to see if a response has been recorded for the first quetsion
    # If a response hasn't been recorded, then the last response sent is assigned to question 1
    # After recording the response, the second question is sent out

    # TODO: create a method for sending the message so that these conditions can get a lot smaller
    if questions[:case_one]
      @user_lead.update_column(:q_one, response)

      @@client.messages.create({
        :from => '+14158010226', 
        :to => @user.phone_number, 
        :body => @question_two
        })
    return render nothing: true

    # Checks to see if the second question has been recorded
    # If it hasn't then the response is recorded as Question 2 and question 3 is sent 
    elsif questions[:case_two]
      @user_lead.update_column(:q_two, response)

      @@client.messages.create({
        :from => '+14158010226', 
        :to => @user.phone_number, 
        :body => @question_three
        })
      return render nothing: true

    # Same logic as above
    elsif questions[:case_three]
      @user_lead.update_column(:q_three, response)

      @@client.messages.create({
        :from => '+14158010226', 
        :to => @user.phone_number, 
        :body => @question_four
        })
      return render nothing: true

    # Same logic as above
    elsif questions[:case_four]
      @user_lead.update_column(:q_four, response)

      @@client.messages.create({
        :from => '+14158010226', 
        :to => @user.phone_number, 
        :body => @question_five
        })
      return render nothing: true

    else
      @user_lead.update_columns({
        :q_five => response, 
        :complete => true,
        :response_url => SecureRandom.uuid
        })

      @@client.messages.create({
        :from => '+14158010226', 
        :to => @user.phone_number, 
        :body => @sending_to_broker
        })

      trigger_lead(@user_lead)

      return render nothing: true
    end
  end

	#####################
	# create_user method
  #####################
  # If a new number texts James, the below method is invoked
  # This method creates a new user record, and then sends the welcome text along with first question
	def create_user(params)
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

    @@client.messages.create(welcome_msg)
	  
    message_one = {
    		:from => '+14158010226', 
        :to => @user.phone_number, 
        :body => @question_one
      }

    @@client.messages.create(message_one)
    create_log(params)
    render nothing: true
	end

  def send_property(to, property)
    user = User.find_by_phone_number(to)
    
    property_found_msg = "Hey #{user.name}! James, here. Good news, I’ve found properties for you that work. A broker validated these and just sent them in. Here they are:"
    property_details_msg = "#{property.sq_ft}sq ft #{property.property_type} in #{property.sub_market} for #{property.max} months at #{property.rent_price}/ft starting rent - vailable #{property.available}."
    broker_msg = "Here's what the broker said, '#{property.description}'. Reply with #{property.response_code} to connect with the broker."

    @@client.messages.create({
        :from => '+14158010226', 
        :to => to, 
        :body => property_found_msg
        })
    @@client.messages.create({
        :from => '+14158010226', 
        :to => to, 
        :body => property_details_msg
        })
    @@client.messages.create({
        :from => '+14158010226', 
        :to => to,
        :body => broker_msg
        })
  end
end
