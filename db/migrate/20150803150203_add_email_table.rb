class AddEmailTable < ActiveRecord::Migration
  def change
    create_table :constructions do |t|
      t.string :email
    end
  end
end
