class AddBrokerToProperty < ActiveRecord::Migration
  def change
  	add_column :properties, :broker_id, :integer
  end
end
