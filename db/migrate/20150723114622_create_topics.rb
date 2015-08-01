class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics  do |t|
      t.string :tid
      #挖掘信息
      t.string :slary
      t.string :area
      t.string :company
      t.string :level
      #本来信息

      t.string :title
      t.datetime :pub_created_at
      t.datetime :pub_updated_at
      t.datetime :replied_at    #最后回复时间
      t.integer :replies_count  #回复数
      t.string :node_name       #节点名称
      t.integer :node_id        #节点id
      t.integer :last_reply_user_id   #最后回复人
      t.string :last_reply_user_login #回复人name
      t.string :user  #发帖人
      t.string :deleted
      t.string :abilities
      t.text :body
      t.text :body_html
      t.integer :hits #查看次数

      t.boolean :isdeal  #:default => false
      #
      t.timestamps null: false
    end
  end
end
