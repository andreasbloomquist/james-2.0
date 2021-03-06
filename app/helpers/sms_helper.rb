module SmsHelper
  include BrokersHelper
  require 'securerandom'

  ###########################
  # Initialize Twilio client
  ###########################
  
  @@client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']

  ######################## 
  # Helper to create an SMS message (plain text)
  ########################
  def create_sms_msg(to, body)
    @@client.messages.create({
        from: '+14158010226',
        to: to,
        body: body
      })
  end

  ######################## 
  # Helper to create an MMS message (include images)
  ########################
  def create_mms_msg(to, property)
    image_arr = []
    property.image_url.load.files.each {|x| image_arr.push(x.cdn_url)}

    @@client.messages.create(
      from: '+14158010226', 
      to: to,
      body: "A few images for #{property.address} from #{property.broker.first_name}",
      media_url: image_arr
    )

  end

  ###########
  # Helper method to send response to user after responding to property
  # and trigger sms to broker
  ###########

  def send_property_response(body, number)
    property = Property.find_by_response_code(body)
    broker_fn = property.broker.first_name
    user = User.find_by_phone_number(number)
    lead = property.leads.where(user_id: user.id).last
    user_number = user.phone_number
    broker_number = property.broker.phone_number
    user_response = "Great! I’ll let #{broker_fn}, the broker, know you’re interested. I'll work on getting some times he's available. Here's #{broker_fn}'s number just to reach them directly, #{broker_number}"
    # Create appointment record to collect brokers available times
    appointment = Appointment.create({
      broker_id: property.broker_id,
      property_id: property.id,
      availability_url: SecureRandom.uuid,
      user_cal_url: SecureRandom.uuid,
      broker_cal_url: SecureRandom.uuid,
      lead_id: lead.id,
      user_id: user.id
      })
    bitly_link = Bitly.client.shorten("https://www.textjames.co/appointments/#{appointment.availability_url}")
    broker_msg = "Hey #{broker_fn}, #{user.name} is interested in the #{property.address} #{property.sq_ft} sq ft space! I’ve given them your number to reach out but in the meantime, why not get started on suggesting some tour times: #{bitly_link.short_url}"
    # Respond to user
    create_sms_msg(user_number, user_response)
    # Respond to broker
    create_sms_msg(broker_number, broker_msg)
    render nothing: true
  end

  #################
  # Helper method to add sms to log tabl
  #################

  def create_log(params)
    SmsLog.create({
                    from: params[:From],
                    to: params[:To],
                    body: params[:Body],
                    sms_id: params[:SmsSid]
                  })
  end

  #############################################################################
  # Method to check the last question the user answered,
  # and respond with a follow question until all questions have been answered.
  #############################################################################

  def send_user_questions(number, response)
    #Find user and last open lead by that user
    @user = User.find_by_phone_number(number)
    @user_lead = @user.leads.last

    ############
    # QUESTIONS
    ############
    # Hard coding questions that Twilio will send depending on the last question answered
    ######################################################################################
    @@question_one = "First, where are you looking- give me one or more neighborhoods: SOMA, FiDi, the Mission, Jackson Square"
    @question_two = 'Ok, and how many people do you need space for?'
    @question_three = 'Do you want a creative/tech or more traditional feel?'
    @question_four = "And when do you need it by? Please give me a date ex: '9/1/15'"
    @question_five = "Sounds good. How long do you think you'll need the space for? Year or less, 1-3 years, or more than 3 years?"
    @question_six = 'Great! Finally, respond with any notes or special requests and my brokers will get right on this!'
    @sending_to_broker = 'I have a team of brokers specializing in this type of space on this right now, so hang tight! I’ll reach out very soon with more info, no need to reply to this text'
    @additional_info = 'In the meantime, a few things. James endeavors to serve you only the freshest market information. Just like the spaces James feeds you, sometimes your query can go stale. To re-submit your last set of criteria for fresh spaces, just type resubmit at any time. To start a new search, text start over. Finally, to stop receiving all texts from James forever, just text James at any time with the word stop.'

    #################
    # QUESTIONS HASH
    #################
    # Questions hash has the truthy falsy values for each question.
    # This is used to quickly check if a question is answered
    ################################################################

    questions = {}
    questions[:case_one] = @user_lead.q_one == nil
    questions[:case_two] = @user_lead.q_two == nil
    questions[:case_three] = @user_lead.q_three == nil
    questions[:case_four] = @user_lead.q_four == nil
    questions[:case_five] = @user_lead.q_five == nil
    questions[:case_six] = @user_lead.q_six == nil

    ###########################
    # SELECT A MESSAGE TO SEND
    ###########################
    # The below checks if each question has been answered
    # If the question hasn't been answered then it records the response and sends a new message

    # Checks to see if a response has been recorded for the first quetsion
    # If a response hasn't been recorded, then the last response sent is assigned to question 1
    # After recording the response, the second question is sent out
    if questions[:case_one]
      @user_lead.update_column(:q_one, response)
      create_sms_msg(number, @question_two)
      return render nothing: true

    # Checks to see if the second question has been recorded
    # If it hasn't then the response is recorded as Question 2 and question 3 is sent 
    elsif questions[:case_two]
      @user_lead.update_column(:q_two, response)
      create_sms_msg(number, @question_three)
      return render nothing: true

    # Same logic as above
    elsif questions[:case_three]
      @user_lead.update_column(:q_three, response)
      create_sms_msg(number, @question_four)
      return render nothing: true

    # Same logic as above
    elsif questions[:case_four]
      @user_lead.update_column(:q_four, response)
      create_sms_msg(number, @question_five)
      return render nothing: true
    
    elsif questions[:case_five]
      @user_lead.update_column(:q_five, response)
      create_sms_msg(number, @question_six)
      return render nothing: true
      
    # If the last question has been anserwed answered AND is not marked complete
    # Then update lead to be complete, log last sms, and create url for broker
    elsif questions[:case_six]
      @user_lead.update_columns({
        q_six: response, 
        complete: true,
        response_url: SecureRandom.uuid
        })
      create_sms_msg(number, @sending_to_broker)
      create_sms_msg(number, @additional_info)
      trigger_lead(@user_lead)
      return render nothing: true
    else
      response_msg = "Hmm, I didn't quite get that, but it looks like you have an open request and our brokers are on it! For additional information and help reply back with 'help me'"
      create_sms_msg(number, response_msg)
      render nothing: true
    end
  end

  ######################
  # send_property method
  ######################
  # This helper is invokved to send a property to a user when the property is brand new

  def send_property(to, property)
    user = User.find_by_phone_number(to)
    property_found_msg = "Hey #{user.name}! James, here. Good news, I’ve found a property for you that work. #{property.broker.first_name} just sent this one in:"
    property_details_msg = "#{property.address} - #{property.sq_ft}sq ft #{property.property_type} space for lease in #{property.sub_market} for #{property.min}-#{property.max} months at $#{property.rent_price}/ft starting rent. Available #{property.available.strftime("%m/%d/%y")}."
    broker_msg = "Here are the notes the broker left you: '#{property.description}'"
    response_code_msg = "Reply with #{property.response_code} to get the contact info for #{property.broker.first_name}. I'll work on getting some tour times in the meantime."
    # When a new property is submitted the following series of texts are sent
    # First message about property being found
    create_sms_msg(to, property_found_msg)
    sleep 1
    # Send details of property
    create_sms_msg(to, property_details_msg)
    sleep 1

    # Send broker notes
    if property.description?
      create_sms_msg(to, broker_msg)
    end

    sleep 1
    create_sms_msg(to, response_code_msg)
    sleep 1
    # Check to see if the response includes a picture
    if property.image_url?
      create_mms_msg(to, property)
    end
  end

  ######################
  # send_previous_props helper
  ######################
  # This helper is invoked when a broker submits properties that were previously entered
  # I separated these helpers so that when multiple previous properties are sent only one intro text is sent

  def send_previous_properties(to, properties, lead)
    user = User.find_by_phone_number(to)
    property = Property.find(properties[0])
    property_found_msg = "Hey #{user.name}! James, here. Good news, I’ve found a property for you that work. #{property.broker.first_name} just sent this one in:"
    # Send property found message
    create_sms_msg(to, property_found_msg)
    sleep 1

    # Iterate through array of properties and send appropriate texts for each property
    properties.each do |id|
      prop = Property.find(id.to_i)
      prop.leads << lead
      property_details_msg = "#{prop.address} - #{prop.sq_ft}sq ft #{prop.property_type} space for lease in #{prop.sub_market} for #{prop.min}-#{prop.max} months at $#{prop.rent_price}/ft starting rent. Available #{prop.available.strftime("%m/%d/%y")}."
      broker_msg = "Here are the notes the broker left you: '#{prop.description}'"
      response_code_msg = "Reply with #{prop.response_code} to get the contact info for #{prop.broker.first_name}. I'll work on getting some tour times in the meantime."

      # Send details of property
      create_sms_msg(to, property_details_msg)
      sleep 2
      
      # Send notes from broker
      if prop.description?
        create_sms_msg(to, broker_msg)
      end

      sleep 1

      create_sms_msg(to, response_code_msg)
      sleep 1

      # Check to see if the response includes a picture
      if prop.image_url?
        create_mms_msg(to, prop)
      end
    end
  end

end
