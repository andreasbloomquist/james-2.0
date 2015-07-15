class AddNotesToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :notes, :string
  end
end
