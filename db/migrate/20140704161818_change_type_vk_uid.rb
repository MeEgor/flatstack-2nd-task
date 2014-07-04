class ChangeTypeVkUid < ActiveRecord::Migration
  def change
    change_column :users, :vk_uid, :string
  end
end
