class RenameCalendarTableToAppointment < ActiveRecord::Migration
  def change
    rename_table :calendar_tables, :appointment
  end
end
