class AppointmentsController < ApplicationController
  include AppointmentsHelper
  
  def show
    @appointment = Appointment.find_by_availability_url(
                                params[:availability_url])
  end

  def update
    @appointment = Appointment.find(params[:availability_url])

    if @appointment.update(appt_params)
      send_available_times(@appointment)
      redirect_to appointment_submitted_path(@appointment.availability_url)
    else
      flash[:error] = 'Update failed. Try again.'
      redirect_to schedule_appointment(@appointment.availability_url)
    end
  end

  def thank_you
  end

  def add_user_cal
    @appointment = Appointment.find_by_user_cal_url(params[:user_cal_url])
    @appointment_start = appointment_time(@appointment)
    @appointment_end = appointment_time(@appointment) + 30*60
  end

  def add_broker_cal
    @appointment = Appointment.find_by_broker_cal_url(params[:broker_cal_url])
    @appointment_start = appointment_time(@appointment)
    @appointment_end = appointment_time(@appointment) + 30*60
  end

  private

  def appt_params
    params.require(:appointment).permit(
                                  :option_one, 
                                  :option_two, 
                                  :option_three, 
                                  :notes)
  end
end
