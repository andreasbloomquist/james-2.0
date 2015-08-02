class UpdateLeadPropertyColumns < ActiveRecord::Migration
  def change
    rename_column :leads_properties, :leads_id, :lead_id
    rename_column :leads_properties, :properties_id, :property_id
  end
end
