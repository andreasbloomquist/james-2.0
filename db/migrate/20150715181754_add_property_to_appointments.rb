class AddPropertyToAppointments < ActiveRecord::Migration
  def change
    add_column :appointment, :property_id, :integer
  end
end
