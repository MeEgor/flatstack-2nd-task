class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.string :remember_token
      t.string :vk_uid
      t.string :phone
      t.string :name

      t.timestamps
    end
  end
end
