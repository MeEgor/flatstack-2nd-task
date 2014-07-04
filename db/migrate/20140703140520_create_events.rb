class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :user, index: true
      t.string :name
      t.date :started_at
      t.integer :period

      t.timestamps
    end
  end
end
