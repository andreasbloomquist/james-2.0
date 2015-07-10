class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.string :address
      t.string :sub_market
      t.string :type
      t.string :sub_market
      t.integer :sq_ft
      t.date :available
      t.string :min
      t.string :max
      t.string :description
      t.string :response_code
     	t.references :lead, index: true, foreign_key: true
     	
      t.timestamps null: false
    end
  end
end
