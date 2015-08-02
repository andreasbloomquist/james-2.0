class CreateLeadsAndProperties < ActiveRecord::Migration
  def change
    create_table :leads_properties, id: false do |t|
      t.belongs_to :leads, index: true
      t.belongs_to :properties, index: true
    end
  end
end
