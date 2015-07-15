class AddColumnsToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :option_one, :datetime
    add_column :appointments, :option_two, :datetime
    add_column :appointments, :option_three, :datetime
    add_column :appointments, :user_response, :string
    add_column :appointments, :calendar_url, :string
    add_column :appointments, :availability_url, :string
    add_column :appointments, :broker_id, :integer
    add_column :appointments, :property_id, :integer
  end
end
