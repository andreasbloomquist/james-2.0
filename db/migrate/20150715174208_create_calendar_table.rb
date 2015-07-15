class CreateCalendarTable < ActiveRecord::Migration
  def change
    create_table :calendar_tables do |t|
      t.datetime :option_one
      t.datetime :option_two
      t.datetime :option_three
      t.string :user_response
      t.string :calendar_url
      t.string :broker_availability_url
      t.references :broker, index: true, foreign_key: true
      t.references :lead, index: true, foreign_key: true
    end
  end
end
