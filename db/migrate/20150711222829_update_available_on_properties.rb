class UpdateAvailableOnProperties < ActiveRecord::Migration
  def change
    change_column :properties, :available,  :datetime
  end
end
