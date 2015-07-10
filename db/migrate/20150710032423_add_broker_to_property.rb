class AddBrokerToProperty < ActiveRecord::Migration
  def change
  	add_foreign_key :properties, :brokers
  end
end
