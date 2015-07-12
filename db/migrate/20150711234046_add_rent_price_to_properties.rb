class AddRentPriceToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :rent_price, :decimal
  end
end
