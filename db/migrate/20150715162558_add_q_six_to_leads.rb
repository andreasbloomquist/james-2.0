class AddQSixToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :q_six, :string
  end
end
