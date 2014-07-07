object false

extends "users/single_user"

node :errors do
  errors = {}
  @user.errors.each do |attribute, errors_array|
    errors[attribute] = errors_array
  end
end

node :info do
  'User update error'
end

node :success do
  false
end
