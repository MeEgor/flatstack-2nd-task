class AddEmailConfirmation < ActiveRecord::Migration
  def change
    add_column :users, :email_confirmation_token, :string
    add_column :users, :email_confirmation_token_expiration_date, :datetime
  end
end
