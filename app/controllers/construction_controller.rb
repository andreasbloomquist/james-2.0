class ConstructionController < ApplicationController
  
  def index
    @construction = Construction.new()
  end

  def email
    @construction = Construction.new(email_params)
    
    respond_to do |format|
      if @construction.save
        format.js
      end
    end
  end
  
  private
  def email_params
    params.require(:construction).permit(:email)
  end
end
