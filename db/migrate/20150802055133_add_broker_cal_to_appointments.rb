class AddBrokerCalToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :broker_cal_url, :string
    rename_column :appointments, :calendar_url, :user_cal_url
  end
end
