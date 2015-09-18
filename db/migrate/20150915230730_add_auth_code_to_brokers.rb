class AddAuthCodeToBrokers < ActiveRecord::Migration
  def change
    add_column :brokers, :auth_code, :integer
  end
end
