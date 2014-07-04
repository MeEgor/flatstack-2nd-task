class ChangeTypeVkUidAgainFix < ActiveRecord::Migration
  def change
    change_column :users, :vk_uid, :integer
  end
end
