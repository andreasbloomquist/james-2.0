class LeadsController < ApplicationController

	def show
		@lead = Lead.find_by_response_url(params[:response_url])
		@property = Property.new
	end

end
