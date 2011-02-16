class CreateMicroposts < ActiveRecord::Migration
  def self.up
    create_table :microposts do |t|
      t.string :content
      t.integer :user_id

      t.timestamps # adds created_at, and updated_at collumns
    end
    add_index :microposts, :user_id  # adds index
  end

  def self.down
    drop_table :microposts
  end
end

