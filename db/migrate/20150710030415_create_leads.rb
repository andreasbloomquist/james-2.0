class CreateLeads < ActiveRecord::Migration
  def change
    create_table :leads do |t|
      t.string :q_one
      t.string :q_two
      t.string :q_three
      t.string :q_four
      t.string :q_five
      t.boolean :complete
      t.references :user, index: true, foreign_key: true
      t.string :response_url

      t.timestamps null: false
    end
  end
end
