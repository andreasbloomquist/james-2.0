class CreateSmsLogs < ActiveRecord::Migration
  def change
    create_table :sms_logs do |t|
      t.string :from
      t.string :to
      t.string :body
      t.string :sms_id

      t.timestamps null: false
    end
  end
end
