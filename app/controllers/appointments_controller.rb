class AppointmentsController < ApplicationController
  include AppointmentsHelper
  
  def show
    p params[:availability_url]
    @appointment = Appointment.find_by_availability_url(params[:availability_url])
  end

  def update
    @appointment = Appointment.find(params[:availability_url])

    if @appointment.update(appt_params)
      send_available_times(@appointment)

      flash[:success] = 'Times added to appointment'
      
      redirect_to root_path
    else
      flash[:error] = 'Update failed. Try again.' 
      redirect_to schedule_appointment(@appointment.availability_url)
    end
  end

  private
  def appt_params
    params.require(:appointment).permit(:option_one, :option_two, :option_three)
  end
end
