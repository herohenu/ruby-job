class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :tid
      t.string :slary
      t.string :area
      t.datetime :pubtime

      t.timestamps null: false
    end
  end
end
