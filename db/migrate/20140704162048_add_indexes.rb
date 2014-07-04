class AddIndexes < ActiveRecord::Migration
  def change
    add_index :users, :email, :unique => true
    add_index :users, :vk_uid
    add_index :users, :remember_token

    add_index :events, :started_at
  end
end
