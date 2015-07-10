class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :phone_number
      t.string :name
      t.string :city
      t.string :state

      t.timestamps null: false
    end
  end
end
