class AddLeadIdToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :lead_id, :integer, index: true
    add_column :appointments, :user_id, :integer, index: true
  end
end
